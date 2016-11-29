class DevicesController < ApplicationController
  before_action :auth
  before_action :set_devices, only: [:index]
  before_action :set_device, only: [:show, :update, :destroy, :log, :relaunch]

  def index
  end

  def show
  end

  def create
    @device = Device.new
    @device.user          = current_team
    @device.name          = device_params[:name]
    @device.device_secret = Digest::SHA1.hexdigest(SecureRandom.uuid)
    @device.board         = device_params[:board]
    @device.tag           = device_params[:tag]
    @device.status        = 'new'
    @device.save!

    render :show
  end

  def update
    @device.update_attributes(device_params)
  end

  def relaunch
    @device.status = 'relaunch'
    @device.save!
  end

  def log
    @log = @device.log_messages(since=log_params[:since] || 0)
  end

  def destroy
    @device.destroy
  end

  private

  def device_params
    params.permit(:name, :board, :tag)
  end

  def log_params
    params.permit(:since)
  end
end
