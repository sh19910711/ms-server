class DevicesController < ApplicationController
  before_action :auth

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
    device = current_team.devices.find_by_name!(params[:device_name])
    device.update_attributes(device_params)
    resp :ok
  end

  private

  def device_params
    params.permit(:name, :board, :tag)
  end
end
