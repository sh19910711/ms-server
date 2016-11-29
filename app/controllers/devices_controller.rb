class DevicesController < ApplicationController
  before_action :auth
  before_action :set_devices, only: [:index]
  before_action :set_device, only: [:show, :update, :destroy, :log, :relaunch]

  def index
    resp :ok, { devices: @devices.index }
  end

  def show
    resp :ok, { device_secret: @device.device_secret }
  end

  def create
    device = Device.new
    device.user          = current_team
    device.name          = device_params[:name]
    device.device_secret = Digest::SHA1.hexdigest(SecureRandom.uuid)
    device.board         = device_params[:board]
    device.tag           = device_params[:tag]
    device.status        = 'new'
    device.save!

    resp :ok, { device_secret: device.device_secret }
  end

  def update
    @device.update_attributes(device_params)
    resp :ok
  end

  def relaunch
    @device.status = 'relaunch'
    @device.save!
    resp :ok
  end

  def log
    resp :ok, { log: @device.log_messages(since=log_params[:since] || 0) }
  end

  def destroy
    @device.destroy
    resp :ok
  end

  private

  def set_devices
    @devices ||= current_team.devices
  end

  def set_device
    set_devices
    @device = @devices.find_by_name!(params[:device_name])
  end

  def device_params
    params.permit(:name, :board, :tag)
  end

  def log_params
    params.permit(:since)
  end
end
