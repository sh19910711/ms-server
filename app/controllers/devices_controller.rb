class DevicesController < ApplicationController

  def status
    device = Device.where(name: device_params[:name]).first_or_initialize
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
