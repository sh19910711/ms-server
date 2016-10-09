require 'rubygems' # rubyzip uses it
require 'zip'

class BuildJob < ApplicationJob
  queue_as :build

  def perform(build_id)
    build = Build.find(build_id)
    logger.info "build ##{build_id}: starting"

    source_url = build.source_file.url
    if source_url.start_with?('/')
      # XXX: saved in the local file system
      source_url = URI.join('http://localhost:3000', source_url)
    end

    # Boot2docker in macOS cannot use directories in volumes
    # other than /Users. https://github.com/docker/compose/issues/1039
    tmp_base_dir = RUBY_PLATFORM.include?("darwin") ? "#{Dir.home}/.cs-build-tmp" : Dir.tmpdir
    FileUtils.mkdir_p(tmp_base_dir)

    Dir.mktmpdir("cs-build-", tmp_base_dir) do |tmpdir|
      Dir.chdir(tmpdir)
      IO.copy_stream(open(source_url), 'app.zip')
      Zip::File.open('app.zip') do |zip_file|
        zip_file.each do |f|
          if [:file, :directory].include?(f.ftype)
            f.extract
          end
        end
      end

      stdout = %x[docker run --rm -v #{tmpdir}:/app -t codestand/baseos 2>&1]
      success = $?.success?

      logger.info "build ##{build_id}: #{success ? 'success' : 'failure'}"

      # update the build status
      build.status = success ? 'success' : 'failure'
      build.log = stdout
      build.remove_source_file!
      build.status = ''
      build.save!

      unless success
        return
      end

      # deploy images
      Dir["*.*.image"].each do |file|
        # TODO: add tag to Build model
        logger.info "build ##{build_id}: deploying #{file}"
        DeployService.new.deploy(build.app, file, File.open(file), nil)
      end
    end
  end
end
