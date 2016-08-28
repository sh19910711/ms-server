class AppsController < ApplicationController
  def index
    render :json => App.all
  end

  def create
    App.create!(apps_params)
    head :ok
  end

  def add_device
    device = Device.find_by_name!(apps_params['device'])
    app = App.find_by_name!(apps_params['name'])
    app.devices += [device]
    app.save!
    head :ok
  end

  private

  def apps_params
    params.permit(:name, :device)
  end
end
