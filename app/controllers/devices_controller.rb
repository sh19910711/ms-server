class DevicesController < ApplicationController
  before_action :auth

  def index
    columns = ['device_secret', 'name', 'board', 'tag']
    devices = []
    current_team.devices.pluck('device_secret', *columns).each do |r|
      device = Hash[columns.zip(r)]
      device['status'] = DeviceStatus.new(device_secret: r[0]).get
      devices << device
    end

    resp :ok, { devices: devices }
  end

  def create
    device = Device.new
    device.user   = current_team
    device.name    = device_params[:name]
    device.device_secret = Digest::SHA1.hexdigest(SecureRandom.uuid)
    device.board   = device_params[:board]
    device.tag     = device_params[:tag]
    device_status = DeviceStatus.new(device_secret: device.device_secret,
                                     status: 'new')

    if device.save && device_status.save
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
