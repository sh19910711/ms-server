class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include CanCan::ControllerAdditions

  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_team
    if @current_team
      return @current_team
    end

    team = User.find_by_name!(params[:team])
    if team != current_user
      raise "You're not allowed to access."
    end

    @current_team = team
  end

  def current_ability
    @current_ability ||= Ability.new(current_team)
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
