class AppsController < ApplicationController
  before_action :auth
  before_action :set_apps, only: [:index, :add_device]
  before_action :set_app, only: [:add_device, :destroy, :show, :log]
  before_action :set_devices, only: [:add_device]

  def index
    resp :ok, { applications: @apps.index }
  end

  def show
    resp :ok, { application: @app }
  end

  def create
    App.create!(user: current_team, name: app_params[:app_name])
    resp :ok
  end

  def destroy
    @app.destroy
    resp :ok
  end

  def add_device
    device = @devices.find_by_name!(add_device_params[:device_name])
    @app.add_device!(device)
    resp :ok
  end

  def log
    resp :ok, { log: @app.log_messages(since=log_params[:since] || 0) }
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
