class AppsController < ApplicationController
  before_action :auth

  def index
    resp :ok, { applications: current_team.apps.select(:name) }
  end

  def create
    app = App.new
    app.name = apps_params[:app_name]
    app.user = current_team

    if app.save
      resp :ok
    else
      resp :unprocessable_entity, { error: 'validation failed', reasons: app.errors.full_messages }
    end
  end

  def add_device
    device = current_team.devices.find_by_name(add_device_params[:device_name])
    unless device
      return resp :not_found, { error: 'device not found' }
    end

    app = current_team.apps.find_by_name!(add_device_params[:app_name])
    unless app
      return resp :not_found, { error: 'app not found' }
    end

    device.app = app
    device.save!
    resp :ok
  end

  def build
    build = Build.new
    build.status = 'queued'
    build.app = App.find_by_name!(build_params[:app_name])
    build.source_file = build_params[:source_file].read
    build.tag = build_params[:tag]

    unless build.save
      resp :unprocessable_entity, { error: 'validation failed', reasons: app.errors.full_messages }
    end

    BuildJob.perform_later(build.id)
    resp :accepted
  end

  def deploy
    DeployService.new.deploy(App.find_by_name!(deploy_params[:app_name]),
                             deploy_params[:group_id],
                             deploy_params[:image].original_filename,
                             deploy_params[:image],
                             deploy_params[:tag])

    resp :ok
  rescue DeployError => e
    resp :unprocessable_entity, { error: e.to_s, reasons: e.reasons }
  end

  private

  def build_params
    params.permit(:app_name, :tag, :source_file)
  end

  def deploy_params
    params.permit(:group_id, :app_name, :tag, :image)
  end

  def apps_params
    params.permit(:app_name)
  end

  def add_device_params
    params.permit(:app_name, :device_name)
  end
end
