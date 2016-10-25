class EnvvarsController < ApplicationController
  before_action :auth
  before_action :set_device
  before_action :set_envvars

  def index
    resp :ok, { envvars: @envvars.select("name", "value").all }
  end

  def update
    envvar = @envvars.where(name: envvar_params[:name]).first_or_create
    envvar.value = envvar_params[:value]

    if envvar.save
      resp :ok
    else
      resp :unprocessable_entity, { error: 'validation failed', reasons: envvar.errors.full_messages }
    end
  end

  def destroy
    @envvars.find_by_name!(envvar_params[:name]).destroy
    resp :ok
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
