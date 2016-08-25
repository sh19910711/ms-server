class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message }, status: :unprocessable_entity
  end
end
