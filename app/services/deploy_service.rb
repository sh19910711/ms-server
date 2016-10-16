class DeployService
  def deploy(app, group_id, filename, file, tag)
    deployment = Deployment.new

    unless file
      return :unprocessable_entity
    end

    unless /.+\.(?<board>.+)\.image$/ =~ filename
      # image file name must be "foo.<board>.image"
      return :unprocessable_entity
    end

    deployment.app      = app
    deployment.group_id = group_id || SecureRandom.uuid
    deployment.board    = board
    deployment.tag      = tag
    deployment.image    = file.read

    if deployment.save
      return :ok
    else
      return :unprocessable_entity
    end
  end
end
