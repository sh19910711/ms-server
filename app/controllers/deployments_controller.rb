class DeploymentsController < ApplicationController
  before_action :set_app, only: [:index, :show, :create]

  def index
    @deployments = @app.deployments
  end

  def show
    major = params[:major]
    minor = params[:minor] || 0

    @deployment = @app.deployments \
                    .where(major_version: major, minor_version: minor)
                    .includes(:build)
                    .first
  end

  def create
    filename = deployment_params[:image].original_filename
    Deployment.create! do |d|
      d.comment  = deployment_params[:comment]
      d.app      = @app
      d.board    = ImageFile.get_board_from_filename(filename)
      d.tag      = deployment_params[:tag]
      d.image    = deployment_params[:image].read
      d.released_at = Time.now
    end
  end

  private

  def deployment_params
    params.permit(:tag, :image, :comment)
  end
end
