class DeploymentsController < ApplicationController
  def index
    resp :ok, { deployments: Deployment.select(:id, :created_at).all }
  end

  def create
    filename = deployment_params[:image].original_filename
    Deployment.create! do |d|
      d.comment  = deployment_params[:comment]
      d.app      = App.find_by_name!(deployment_params[:app_name])
      d.group_id = deployment_params[:group_id]
      d.board    = ImageFile.get_board_from_filename(filename)
      d.tag      = deployment_params[:tag]
      d.image    = deployment_params[:image].read
    end

    resp :ok
  end

  private

  def deployment_params
    params.permit(:group_id, :app_name, :tag, :image, :comment)
  end
end
