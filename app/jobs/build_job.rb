require 'rubygems' # rubyzip uses it
require 'zip'

class BuildJob < ApplicationJob
  queue_as :build

  def perform(build_id)
    build = Build.find(build_id)
    start_build(build)

    success = false
    stdout = ''
    tmp_base_dir = prepare_tmp_base_dir
    Dir.mktmpdir("makestack-app-build-", tmp_base_dir) do |tmpdir|
      app_zip = File.join(tmpdir, 'app.zip')
      IO.binwrite(app_zip, build.source_file)

      success, stdout = extract_zip(app_zip, tmpdir)
      break unless success

      success, stdout = build(tmpdir)
      break unless success

      group_id = SecureRandom.uuid
      image_files = Dir[File.join(tmpdir, "*.*.image")]
      if image_files == []
        stdout += "\nno image files to deploy\n"
        success = false
        break
      end

      success, stdout = deploy_images(build, group_id, image_files)
      break unless success
    end

    finish_build(build, success, stdout)
  end

  private

  def start_build(build)
    logger.info "build ##{build.id}: starting"
    build.update!(status: 'building')
    build
  end

  def finish_build(build, success, stdout)
    logger.info "build ##{build.id}: #{success ? 'success' : 'failure'}"
    build.status = success ? 'success' : 'failure'
    build.log = stdout
    build.source_file = nil
    build.save!
  end

  def prepare_tmp_base_dir
    tmp_base_dir = "#{Dir.home}/.makestack-server.d/builds"
    FileUtils.mkdir_p(tmp_base_dir)
    tmp_base_dir
  end

  def extract_zip(app_zip, tmpdir)
    begin
      Zip::File.open(app_zip) do |zip_file|
        zip_file.each do |f|
          if [:file, :directory].include?(f.ftype)
            f.extract(File.join(tmpdir, f.name))
          end
        end
      end
    rescue Zip::Error
      return false, 'invalid zip file'
    end

    return true, ''
  end

  def build(appdir)
    stdout  = %x[docker run --rm -v #{appdir}:/app -t makestack/os 2>&1]
    if $?.success?
      return true, stdout
    else
      return false, stdout + "\nfailed to build\n"
    end
  end

  def deploy_images(build, group_id, image_files)
    image_files.each do |file|
      logger.info "build ##{build.id}: deploying #{file}"
      Deployment.create! do |d|
        d.comment  = build.comment
        d.app      = build.app
        d.group_id = group_id
        d.board    = ImageFile.get_board_from_filename(file)
        d.tag      = build.tag
        d.image    = File.open(file, 'rb').read
      end
    end

    return true, ''
  end
end
