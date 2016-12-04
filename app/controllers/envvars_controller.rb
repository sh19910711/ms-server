class EnvvarsController < ApplicationController
  before_action :auth
  before_action :set_device
  before_action :set_envvars

  def index
  end

  def update
    envvar = @envvars.where(name: envvar_params[:name]).first_or_create
    envvar.value = envvar_params[:value]
    envvar.save!
  end

  def destroy
    envvar = @envvars.find_by_name(envvar_params[:name])
    unless envvar
      render_error :not_found, "No such envvar."
      return
    end

    envvar.destroy
  end

  private

  def set_envvars
    @envvars = @device.envvars
  end

  def envvar_params
    params.permit(:deivce_name, :name, :value)
  end
end
