class DevicesController < ApplicationController

  def status
    device = Device.find_or_create_by(name: device_params[:name])
    device.status = device_params[:status]
    device.save
  end

  private

  def device_params
    params.require(:device).permit(:name, :status)
  end
end
