class DevicesController < ApplicationController

  def index
    devices = Device.select("name", "board", "status").all
    render json: { devices: devices }
  end
  
  def status
    device = Device.where(name: device_params[:name]).first_or_initialize
    device.board  = device_params[:board]
    device.status = device_params[:status]
    device.save!
    head :ok
  end

  def image
    device = Device.find_by_name(device_params[:name])
    unless device
      logger.info "the device not found"
      return head :not_found
    end

    if device.apps == []
      logger.info "the device is not associated to an app"
      return head :not_found
    end

    # TODO: support multi-apps
    app = device.apps.first

    deployment = Deployment.where(app: app).order("created_at").last
    unless deployment
      logger.info "no deployments"
      return head :not_found
    end

    image = Image.where(deployment: deployment, board: device.board).first
    unless image
      logger.info "no image uploaded for the device in the deploment"
      return head :not_found
    end

    # TODO: replace send_file with a redirection
    # Since BaseOS does not support redirection we cannot use it.
    send_file image.file.current_path, status: :ok
  end

  private

  def device_params
    params.permit(:name, :board, :status)
  end
end
