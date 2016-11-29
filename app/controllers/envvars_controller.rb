class EnvvarsController < ApplicationController
  before_action :auth
  before_action :set_device
  before_action :set_envvars

  def index
  end

  def update
    envvar = @envvars.where(name: envvar_params[:name]).first_or_create
    envvar.value = envvar_params[:value]

    unless envvar.save
      render status: :unprocessable_entity, json: { error: 'validation failed', reasons: envvar.errors.full_messages }
      return
    end
  end

  def destroy
    @envvars.find_by_name!(envvar_params[:name]).destroy
  end

  private

  def set_device
    @device = current_team.devices.find_by_name!(params[:device_name])
  end

  def set_envvars
    @envvars = @device.envvars
  end

  def envvar_params
    params.permit(:deivce_name, :name, :value)
  end
end
