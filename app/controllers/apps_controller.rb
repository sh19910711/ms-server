class AppsController < ApplicationController
  before_action :auth

  def index
    render :json => { :applications => current_team.apps.select(:name) }
  end

  def create
    app = App.new
    app.name = apps_params[:name]
    app.user = current_team

    if app.save
      head :ok
    else
      render status: :unprocessable_entity, json: { errors: app.errors.full_messages }
    end
  end

  def add_device
    device = current_team.devices.find_by_name!(add_device_params[:device])
    app = current_team.apps.find_by_name!(add_device_params[:name])
    app.devices += [device]
    app.save!
    head :ok
  end

  def deploy_image
    deployment = Deployment.new

    image_file = deployment_params[:image]
    unless image_file
      head :unprocessable_entity
    end

    unless /.+\.(?<board>.+)\.image/ =~ image_file.original_filename
      # image file name must be "foo.<board>.image"
      head :unprocessable_entity
    end

    deployment.app   = App.find_by_name(deployment_params[:name])
    deployment.board = board
    deployment.tag   = deployment_params[:tag]
    deployment.image = image_file

    if deployment.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def deployment_params
    params.permit(:name, :tag, :image)
  end

  def apps_params
    params.permit(:name)
  end

  def add_device_params
    params.permit(:name, :device)
  end
end
