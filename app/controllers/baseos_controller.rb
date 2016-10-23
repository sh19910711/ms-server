class BaseosController < ApplicationController
  before_action :auth_device

  def heartbeat
    @device.status = heartbeat_params[:status]
    @device.heartbeated_at = Time.now
    @device.save!

    deployment  = get_latest_deployment
    latest_version = deployment ? deployment.id.to_s : 'X'
    render body: latest_version
  end

  def image
    if image_params[:deployment_id]
      # deployment ID can be specified by the client (device). Devices that
      # does not have enough memory downloads an image using Range.
      #
      # This prevents downloading a different image which have deployed
      # during downloading an older image.
      deployment = Deployment.find_by_id(image_params[:deployment_id])
      unless deployment
        return head :not_found
      end

      unless @device.app
        return head :forbidden
      end

      if @device.app != deployment.app or
        deployment.board != @device.board or
        (deployment.tag != nil and deployment.tag != device.tag)
        return head :not_found
      end
    else
      deployment = get_latest_deployment
      unless deployment
        return head :not_found
      end
    end

    handle_range_header(image_params[:deployment_id], deployment.image)
  end

  private

  def get_latest_deployment
    unless @device
      logger.info "the device not found"
      return nil
    end

    unless @device.app
      logger.info "the device is not associated to an app"
      return nil
    end

    deployment = Deployment.where(app: @device.app,
                                  board: @device.board,
                                  tag: [@device.tag, nil]).order("created_at").last

    unless deployment
      logger.info "no deployments"
      return nil
    end

    deployment
  end


  def auth_device
    @device = Device.find_by_device_secret(params[:device_secret])
    unless @device
      head :forbidden
      return false
    end
  end


  def handle_range_header(deployment_id, file)
    filesize = file.size
    partial = false # send whole data by default
    if request.headers["Range"]
      unless deployment_id
        # What if another new deployment is created during download?
        return head :bad_request
      end

      if /bytes=(?<offset>\d+)-(?<offset_end>\d*)/ =~ request.headers['Range']
        partial = true
        offset = offset.to_i
        offset_end =  (offset_end == "") ? filesize : offset_end.to_i
        length = offset_end - offset

        if offset < 0 || length < 0
          return head :bad_request
        end
      else
        return head :bad_request
      end
    end

    if partial
      response.header['Content-Length'] = "#{length}"
      response.header['Content-Range']  = "bytes #{offset}-#{offset_end}/#{filesize}"
      send_data file[offset, length], status: :partial_content, disposition: "inline"
    else
      send_data file, status: :ok
    end
  end

  def heartbeat_params
    params.permit(:device_secret, :status)
  end

  def image_params
    params.permit(:device_secret, :deployment_id)
  end
end
