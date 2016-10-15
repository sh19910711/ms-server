class DevicesController < ApplicationController
  before_action :auth, except: [:status, :image]
  before_action :auth_device, only: [:status, :image]
  before_action :set_current_team, only: [:index, :create, :update]

  def index
    devices = current_team.devices.select("name", "board", "status").all
    render json: { devices: devices }
  end

  def create
    device = Device.new
    device.user   = current_team
    device.name    = device_params[:name]
    device.device_secret = Digest::SHA1.hexdigest(SecureRandom.uuid)
    device.board   = device_params[:board]
    device.status  = 'new'
    device.tag     = device_params[:tag]
    device.save!

    render json: { device_secret: device.device_secret }
  end

  def update
    device = current_team.devices.find_by_device_secret!(device_params[:device_secret])
    device.update_attributes(devce_params)
  end

  def status
    device = Device.find_by_device_secret!(device_params[:device_secret])
    device.status = device_params[:status]
    device.heartbeated_at = Time.now
    device.save!

    deployment  = get_deployment(device_params[:device_secret])
    latest_version = deployment ? deployment.id.to_s : 'X'
    render body: latest_version
  end

  def image
    if device_params[:deployment_id]
      # deployment ID can be specified by the client (device). Devices that
      # does not have enough memory downloads an image using Range.
      #
      # This prevents downloading a different image which have deployed
      # during downloading an older image.
      deployment = Deployment.find_by_id(device_params[:deployment_id])
      unless deployment
        return head :not_found
      end

      # TODO: support multi-apps
      if @device.apps == [] or @device.apps.first != deployment.app or
        deployment.board != @device.board or
        (deployment.tag != nil and deployment.tag != device.tag)
        return head :not_found
      end
    else
      deployment = get_deployment(device_params[:device_secret])
      unless deployment
        return head :not_found
      end
    end

    # TODO: replace send_file with a redirection
    # Since BaseOS does not support redirection we cannot use it.
    filepath = deployment.image.current_path
    filesize = File.size?(filepath)

    partial = false # send whole data by default
    if request.headers["Range"]
      unless device_params[:deployment_id]
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
      send_data IO.binread(filepath, length, offset),
                status: :partial_content, disposition: "inline"
    else
      send_file deployment.image.current_path, status: :ok
    end
  end

  private

  def get_deployment(device_secret)
    device = Device.find_by_device_secret(device_secret)
    unless device
      logger.info "the device not found"
      return nil
    end

    if device.apps == []
      logger.info "the device is not associated to an app"
      return nil
    end

    # TODO: support multi-apps
    app = device.apps.first

    deployment = Deployment.where(app: app,
                                  board: device.board,
                                  tag: [device.tag, nil]).order("created_at").last

    unless deployment
      logger.info "no deployments"
      return nil
    end

    deployment
  end

  def set_current_team
    @current_team = User.find_by_name!(params[:team])
  end

  def auth_device
    @device = Device.find_by_device_secret(params[:device_secret])
    unless @device
      head :forbidden
      return false
    end
  end

  def device_params
    params.permit(:device_secret, :name, :board, :status, :tag, :deployment_id)
  end
end
