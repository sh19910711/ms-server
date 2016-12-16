class BuildError < StandardError
end

class BuildJob < ApplicationJob
  queue_as :build

  def perform(deployment_id, build_id)
    deployment = Deployment.find(deployment_id)
    build = Build.find(build_id)

    begin
      start_build(build)

      tmp_base_dir = prepare_tmp_base_dir
      Dir.mktmpdir("makestack-app-build-", tmp_base_dir) do |tmpdir|
        IO.binwrite(File.join(tmpdir, 'app.zip'), build.source_file)
        build(build, tmpdir)
        deploy_images(deployment, build, get_image_files(tmpdir))
      end

      finish_build(build)
    rescue BuildError => e
      build.status = 'failure'
      build.log += "\n#{e}\n"
      build.save!
    end
  end

  private

  def get_image_files(tmpdir)
    image_files = Dir[File.join(tmpdir, "*.*.image")]
    if image_files == []
      raise BuildError, "no image files to deploy"
    end

    image_files
  end

  def start_build(build)
    logger.info "build ##{build.id}: starting"
    build.update!(status: 'building')
    build.log = ""
    build
  end

  def finish_build(build)
    logger.info "build ##{build.id}: #{build.status}"
    build.source_file = nil
    build.save!
  end

  def prepare_tmp_base_dir
    tmp_base_dir = "#{Dir.home}/.makestack-server.d/builds"
    FileUtils.mkdir_p(tmp_base_dir)
    tmp_base_dir
  end

  def build(build, appdir)
    build.log += %x[docker run --rm -v #{appdir}:/app -t makestack/os 2>&1]
    if $?.success?
      build.status = 'success'
    else
      build.status = 'failure'
      raise BuildError, "failed to build"
    end
  end

  def deploy_images(deployment, build, image_files)
    comment =  deployment.comment
    app = deployment.app
    tag = deployment.tag
    major_version =  deployment.major_version
    minor_version = (image_files.size == 0)? 0 : 1
    released_at = Time.now

    ActiveRecord::Base.transaction do
      image_files.each do |file|
        logger.info "build ##{build.id}: deploying #{file}"
        Deployment.create! do |d|
          d.comment       = comment
          d.app           = app
          d.major_version = major_version
          d.minor_version = minor_version
          d.tag           = tag
          d.board         = ImageFile.get_board_from_filename(file)
          d.image         = File.open(file, 'rb').read
          d.released_at   = released_at
          d.build         = build
        end
        minor_version += 1
      end

      deployment.destroy
    end
  end
end
