class DevicesController < ApplicationController
  before_action :auth
  before_action :set_current_team

  def index
    devices = current_team.devices.select("name", "board", "status", "tag").all
    resp :ok, { devices: devices }
  end

  def create
    device = Device.new
    device.user   = current_team
    device.name    = device_params[:name]
    device.device_secret = Digest::SHA1.hexdigest(SecureRandom.uuid)
    device.board   = device_params[:board]
    device.status  = 'new'
    device.tag     = device_params[:tag]

    if device.save
      resp :ok, { device_secret: device.device_secret }
    else
      resp :unprocessable_entity, { error: 'validation failed', reasons: device.errors.full_messages }
    end
  end

  def update
    device = current_team.devices.find_by_device_secret!(device_params[:device_secret])
    device.update_attributes(devce_params)
    resp :ok
  end

  private

  def set_current_team
    @current_team = User.find_by_name!(params[:team])
  end

  def device_params
    params.permit(:name, :board, :tag)
  end
end
