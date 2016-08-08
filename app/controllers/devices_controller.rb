class DevicesController < ApplicationController

  def status
    device = Device.find_or_create_by(name: device_params[:name])
    device.board  = device_params[:board]
    device.status = device_params[:status]
    device.save!
    head :ok
  end

  private

  def device_params
    params.permit(:name, :board, :status)
  end
end
