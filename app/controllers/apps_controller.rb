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
    device = current_team.devices.find_by_name!(apps_params['device'])
    app = current_team.apps.find_by_name!(apps_params['name'])
    app.devices += [device]
    app.save!
    head :ok
  end

  def deploy_image
    deployment = Deployment.new
    deployment.app   = App.find_by_name(deployment_params[:name])
    deployment.tag   = deployment_params[:tag]
    deployment.board = deployment_params[:board]
    deployment.file  = deployment_params[:file]

    if deployment.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def deployment_params
    params.permit(:name, :tag, :board, :file)
  end

  def apps_params
    params.permit(:name, :device)
  end
end
