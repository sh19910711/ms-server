class DeploymentsController < ApplicationController
  def create

    deployment = Deployment.new
    deployment.app   = App.find_by_name(deployment_params[:name])
    deployment.tag   = deployment_params[:tag]
    deployment.board = deployment_params[:board]
    deployment.file  = deployment_params[:file]

    if deployment.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def deployment_params
    params.permit(:name, :tag, :board, :file)
  end
end
