class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
