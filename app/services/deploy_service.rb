class DeployError < StandardError
  attr_reader :reasons
  def initialize(msg, reasons=[])
    @msg = msg
    @reasons = reasons
  end

  def to_s
    @msg
  end
end


class DeployService
  def deploy(app, group_id, filename, file, tag)
    deployment = Deployment.new

    unless file
      raise DeployError.new("file is not uploaded")
    end

    unless /.+\.(?<board>.+)\.image$/ =~ filename
      # image file name must be "foo.<board>.image"
      raise DeployError.new("invalid image filename")
    end

    deployment.app      = app
    deployment.group_id = group_id || SecureRandom.uuid
    deployment.board    = board
    deployment.tag      = tag
    deployment.image    = file.read

    unless deployment.save
      raise DeployError.new('validation failed', deployment.errors.full_messages)
    end
  end
end
