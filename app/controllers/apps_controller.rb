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
    device.app = current_team.apps.find_by_name!(add_device_params[:name])
    device.save!
    head :ok
  end

  def build
    build = Build.new
    build.status = 'queued'
    build.app = App.find_by_name!(build_params[:name])
    build.source_file = build_params[:source_file].read
    build.tag = build_params[:tag]
    build.save!

    BuildJob.perform_later(build.id)
    head :accepted
  end

  def deploy
    head DeployService.new.deploy(App.find_by_name!(deploy_params[:name]),
                                  deploy_params[:group_id],
                                  deploy_params[:image].original_filename,
                                  deploy_params[:image],
                                  deploy_params[:tag])
  end

  private

  def build_params
    params.permit(:name, :tag, :source_file)
  end

  def deploy_params
    params.permit(:group_id, :name, :tag, :image)
  end

  def apps_params
    params.permit(:name)
  end

  def add_device_params
    params.permit(:name, :device)
  end
end
