class DeployService
  def deploy(app, image_filename, image_file, tag)
    deployment = Deployment.new

    unless image_file
      return :unprocessable_entity
    end

    unless /.+\.(?<board>.+)\.image$/ =~ image_filename
      # image file name must be "foo.<board>.image"
      return :unprocessable_entity
    end

    deployment.app   = app
    deployment.board = board
    deployment.tag   = tag
    deployment.image = image_file

    if deployment.save
      return :ok
    else
      return :unprocessable_entity
    end
  end
end
