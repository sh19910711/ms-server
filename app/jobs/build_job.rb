class BuildError < StandardError
end

class BuildJob < ApplicationJob
  queue_as :build

  def perform(deployment_id)
    deployment = Deployment.find(deployment_id)

    begin
      start_build(deployment)
      setup

      tmp_base_dir = prepare_tmp_base_dir
      Dir.mktmpdir("makestack-app-build-", tmp_base_dir) do |tmpdir|
        IO.binwrite(File.join(tmpdir, "app.zip"), deployment.source_file)
        build(deployment, tmpdir)
        deploy(deployment, get_image_file(tmpdir))
      end

      finish_build(deployment)
    rescue BuildError => e
      deployment.status = "failure"
      deployment.buildlog += "\n#{e}\n"
      deployment.save!
    end
  end

  private

  def setup
    # TODO
    # deployment.build += ">>> stage: infra\n"
    # deployment.build += ">>> action: Build Environment Info\n"
    # deployment.build += ">>> action_end: success\n"
    # deployment.build += ">>> action: Pull Docker image\n"
    # deployment.build += ">>> action_end: success\n"
    # deployment.build += ">>> stage_end: success\n"
  end

  def get_image_file(tmpdir)
    image_files = Dir[File.join(tmpdir, "*.*.image")]
    if image_files == []
      raise BuildError, "no image files to deploy"
    end

    image_files[0]
  end

  def start_build(deployment)
    logger.info "build ##{deployment.id}: starting"
    deployment.update!(status: 'building')
    deployment.buildlog = ""
  end

  def finish_build(deployment)
    logger.info "build ##{deployment.id}: #{deployment.status}"
    deployment.source_file = nil
    deployment.save!
  end

  def prepare_tmp_base_dir
    tmp_base_dir = "#{Dir.home}/.makestack-server.d/builds"
    FileUtils.mkdir_p(tmp_base_dir)
    tmp_base_dir
  end

  def build(deployment, appdir)
    deployment.buildlog += ">>> stage: build\n"
    deployment.buildlog += ">>> action: Build the app image\n"
    deployment.buildlog += %x[docker run --rm -v #{appdir}:/app -t makestack/os 2>&1].chomp("\n") + "\n"
    status = ($?.success?)? "success" : "failure"
    deployment.buildlog += ">>> action_end: #{status}\n"
    deployment.buildlog += ">>> stage_end\n"

    if status == "success"
      deployment.status = status
    else
      deployment.status = status
      raise BuildError, "failed to build"
    end
  end

  def deploy(deployment, image_file)
    logger.info "build ##{deployment.id}: deploying #{image_file}"
    deployment.buildlog += ">>> stage: deploy\n"
    deployment.buildlog += ">>> action: Deploy the built image\n"
    deployment.board = ImageFile.get_board_from_filename(image_file)
    deployment.image = File.open(image_file, 'rb').read
    deployment.released_at = Time.now
    deployment.save!

    deployment.buildlog += ">>> action_end: success\n"
    deployment.buildlog += ">>> stage_end\n"
    deployment.save!
  end
end
