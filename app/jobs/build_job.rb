require 'rubygems' # rubyzip uses it
require 'zip'

class BuildJob < ApplicationJob
  queue_as :build

  def perform(build_id)
    build = Build.find(build_id)
    logger.info "build ##{build_id}: starting"
    build.update!(status: 'building')

    # Boot2docker in macOS cannot use directories in volumes
    # other than /Users. https://github.com/docker/compose/issues/1039
    tmp_base_dir = RUBY_PLATFORM.include?("darwin") ? "#{Dir.home}/.cs-build-tmp" : Dir.tmpdir
    FileUtils.mkdir_p(tmp_base_dir)

    Dir.mktmpdir("cs-build-", tmp_base_dir) do |tmpdir|
      app_zip = File.join(tmpdir, 'app.zip')
      IO.binwrite(app_zip, build.source_file)

      begin
        Zip::File.open(app_zip) do |zip_file|
          zip_file.each do |f|
            if [:file, :directory].include?(f.ftype)
              f.extract(File.join(tmpdir, f.name))
            end
          end
        end
      rescue Zip::Error
        success = false
      else
        stdout = %x[docker run --rm -v #{tmpdir}:/app -t codestand/baseos 2>&1]
        success = $?.success?
      end

      logger.info "build ##{build_id}: #{success ? 'success' : 'failure'}"

      # update the build status
      build.status = success ? 'success' : 'failure'
      build.log = stdout
      build.source_file = nil
      build.save!

      unless success
        break
      end

      # deploy images
      group_id = SecureRandom.uuid
      Dir["*.*.image"].each do |file|
        logger.info "build ##{build_id}: deploying #{file}"
        Deployment.create! do |d|
          d.app      = build.app
          d.group_id = group_id
          d.board    = ImageFile.get_board_from_filename(file)
          d.tag      = build.tag
          d.image    = File.open(file).read
        end
      end
    end
  end
end
