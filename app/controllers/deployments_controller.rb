class DeploymentsController < ApplicationController
  before_action :set_app, only: [:index, :create]

  def index
    @deployments = @app.deployments
  end

  def create
    filename = deployment_params[:image].original_filename
    Deployment.create! do |d|
      d.comment  = deployment_params[:comment]
      d.app      = @app
      d.group_id = deployment_params[:group_id]
      d.board    = ImageFile.get_board_from_filename(filename)
      d.tag      = deployment_params[:tag]
      d.image    = deployment_params[:image].read
    end
  end

  private

  def deployment_params
    params.permit(:group_id, :app_name, :tag, :image, :comment)
  end
end
