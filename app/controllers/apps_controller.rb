class AppsController < ApplicationController
  before_action :auth
  before_action :set_apps, only: [:index, :add_device]
  before_action :set_app, only: [:add_device, :destroy, :show, :log]
  before_action :set_devices, only: [:add_device]

  def index
  end

  def show
  end

  def create
    @app = App.new
    @app.user = current_team
    @app.name = app_params[:app_name]
    @app.save!
    render :show
  end

  def destroy
    @app.destroy
  end

  def add_device
    device = @devices.find_by_name(add_device_params[:device_name])
    unless device
      render_error :not_found, "No such device."
    end

    @app.add_device!(device)
  end

  def log
    @log = @app.log_messages(since=log_params[:since] || 0)
  end

  private

  def app_params
    params.permit(:app_name)
  end

  def add_device_params
    params.permit(:app_name, :device_name)
  end

  def log_params
    params.permit(:log)
  end
end
