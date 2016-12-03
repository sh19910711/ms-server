class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  if not Rails.env.development? and not Rails.env.test?
    rescue_from Exception, with: :handle_500
  end

  if not Rails.env.development?
    rescue_from ActionController::RoutingError, with: :handle_routing_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_404
  end

  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error

  before_action :handle_api_version
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def handle_500(e)
    log_exception e
    head :internal_server_error
  end

  def handle_validation_error(m)
    render status: :unprocessable_entity, json: {
                 error: 'validation error',
                 validation_errors: m.record.errors.messages
             }
  end

  def handle_routing_error
    head :bad_request
  end

  def handle_404(e)
    log_exception e
    head :not_found
  end

  def handle_api_version
    client_ver = request.headers['API-Version']
    if client_ver and not client_ver.split(',').map(&:strip).include?(API_VERSION)
      head :not_acceptable
      return false
    end

    response.headers['API-Version'] = API_VERSION
  end

  def auth
    authenticate_user!

    team = User.find_by_name(params[:team])
    if team != current_user
      head :forbidden
      return false
    end

    @current_team = team
  end

  def current_team
    auth
    @current_team
  end

  def current_ability
    @current_ability ||= Ability.new(current_team)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
  end

  def log_exception(e)
    logger.error "Exception: #{e}"
    logger.error "Backtrace:"
    e.backtrace.each do |l|
      logger.error "\t#{l}"
    end
  end

  def set_apps
    @apps ||= current_team.apps
  end

  def set_app
    set_apps

    @app ||= @apps.find_by_name(params[:app_name])
    unless @app
      render_error :not_found, "No such app."
      return false
    end
  end

  def set_devices
    @devices ||= current_team.devices
  end

  def set_device
    set_devices

    @device ||= @devices.find_by_name(params[:device_name])
    unless @device
      render_error :not_found, "No such device."
      return false
    end
  end

  def render_error(status, message)
    render status: status, json: { error: message }
  end
end
