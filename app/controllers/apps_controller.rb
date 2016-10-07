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

  private

  def apps_params
    params.permit(:name, :device)
  end
end
