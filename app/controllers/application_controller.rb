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

  prepend_around_action :handle_auth_token
  before_action :handle_api_version
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_email_in_sign_in

  protected

  def handle_500(e)
    log_exception e
    head :internal_server_error
  end

  def handle_validation_error(e)
    resp :unprocessable_entity, { reasons: e.record.errors }
  end

  def handle_routing_error
    head :bad_request
  end

  def handle_404
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

  def set_email_in_sign_in
    if controller_name == 'sessions' and action_name == 'create'
      user = User.find_by_name(params[:username])

      unless user
        head :unauthorized
        return false
      end

      params[:email] = user.email
    end
  end

  def handle_auth_token
    # device_token_auth uses 3 variables to authenticate. That's so painful.
    # Let's put them together in this around_action.
    if /^token (?<token>.+)$/ =~ request.headers['Authorization']
      auth_token = AuthToken.find_by_token(token)
      unless auth_token
        head :unauthorized
        return
      end

      # TODO: implement token expiration

      request.headers['uid']          = auth_token.uid
      request.headers['client']       = auth_token.client
      request.headers['access-token'] = auth_token.access_token
    end

    yield

    if response.headers['access-token']
      # It seems the client is about to sign in. Store and remove header fields
      # from device_token_auth and allocate a single auth token.
      auth_token = AuthToken.new
      auth_token.token        = Digest::SHA1.hexdigest(SecureRandom.base64(128))
      auth_token.uid          = response.headers['uid']
      auth_token.client       = response.headers['client']
      auth_token.access_token = response.headers['access-token']
      auth_token.expires_at   = 30.days.from_now

      unless auth_token.save
        head :internal_server_error
        return
      end

      response.headers['Username'] = User.find_by_uid!(auth_token.uid).name
      response.headers['Token']    = auth_token.token
      %w(uid client access-token expiry token-type).each {|x| response.headers.delete(x) }
    end
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

  def resp(status, json={})
    render status: status, json: json
  end

  def log_exception(e)
    logger.error "Exception: #{e}"
    logger.error "Backtrace:"
    e.backtrace.each do |l|
      logger.error "\t#{l}"
    end
  end
end
