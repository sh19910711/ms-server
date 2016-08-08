class AppsController < ApplicationController

  def create
    App.create!(apps_params)
    head :ok
  end

  private

  def apps_params
    params.permit(:name)
  end
end
