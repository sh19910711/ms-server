class DevicesController < ApplicationController
  before_action :auth
  before_action :set_devices, only: [:index, :update, :logging]
  before_action :set_device, only: [:update, :logging]

  def index
    resp :ok, { devices: @devices.index }
  end

  def create
    device_secret = Digest::SHA1.hexdigest(SecureRandom.uuid)
    Device.create! do |device|
      device.user          = current_team
      device.name          = device_params[:name]
      device.device_secret = device_secret
      device.board         = device_params[:board]
      device.tag           = device_params[:tag]
      device.status        = 'new'
    end

    resp :ok, { device_secret: device_secret }
  end

  def update
    @device.update_attributes(device_params)
    resp :ok
  end

  def logging
    resp :ok, { logging: Logging.new(device_secret: @device.device_secret).get }
  end

  private

  def set_devices
    @devices = current_team.devices
  end

  def set_device
    @device = @devices.find_by_name!(params[:device_name])
  end

  def device_params
    params.permit(:name, :board, :tag)
  end
end
