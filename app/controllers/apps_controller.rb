class AppsController < ApplicationController
  before_action :auth
  before_action :set_apps, only: [:index, :add_device]

  def index
    resp :ok, { applications: @apps.index }
  end

  def create
    App.create!(user: current_team, name: app_params[:app_name])
    resp :ok
  end

  def add_device
    app = @apps.find_by_name!(add_device_params[:app_name])
    device = Device.find_by_name!(add_device_params[:device_name])
    device.app = app

    device.save!
    resp :ok
  end

  def build
    app = App.find_by_name!(build_params[:app_name])
    build = Build.new(status: 'queued', tag: build_params[:tag], app: app)
    build.source_file = build_params[:source_file].read

    build.save!
    BuildJob.perform_later(build.id)
    resp :accepted
  end

  def deploy
    filename = deploy_params[:image].original_filename
    Deployment.create! do |d|
      d.app      = App.find_by_name!(deploy_params[:app_name])
      d.group_id = deploy_params[:group_id]
      d.board    = ImageFile.get_board_from_filename(filename)
      d.tag      = deploy_params[:tag]
      d.image    = deploy_params[:image].read
    end

    resp :ok
  end

  private

  def set_apps
    @apps = current_team.apps
  end

  def build_params
    params.permit(:app_name, :tag, :source_file)
  end

  def deploy_params
    params.permit(:group_id, :app_name, :tag, :image)
  end

  def app_params
    params.permit(:app_name)
  end

  def add_device_params
    params.permit(:app_name, :device_name)
  end
end
