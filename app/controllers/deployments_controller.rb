class DeploymentsController < ApplicationController
  before_action :set_app, only: [:index, :show, :create]

  def index
    @deployments = @app.deployments
  end

  def show
    @deployment = @app.deployments.find_by_version(params[:version])
  end

  def create
    if deployment_params[:image]
      filename    = deployment_params[:image].original_filename
      boards      = [ImageFile.get_board_from_filename(filename)]
      image       = deployment_params[:image].read
      source_file = nil
    else
      unless deployment_params[:source_file]
        render_error :bad_request, "Specify `image' or `source_file'."
        return
      end

      boards = @app.devices.pluck(:board).uniq
      if boards == []
        render_error :not_acceptable, "No devices associated to the app."
        return
      end

      image       = nil
      source_file = deployment_params[:source_file].read
    end

    @deployments = boards.map do |board|
      deployment = Deployment.new
      deployment.app         = @app
      deployment.board       = board
      deployment.image       = image
      deployment.source_file = source_file
      deployment.status      = (image)? "success" : "queued"
      deployment.comment     = deployment_params[:comment]
      deployment.tag         = deployment_params[:tag]
      deployment.released_at = (image)? Time.now : nil
      deployment.save!

      if source_file
        deployment.build
      end

      deployment
    end
  end

  private

  def deployment_params
    params.permit(:tag, :image, :comment, :tag, :source_file)
  end
end
