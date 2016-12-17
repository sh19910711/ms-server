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
      board       = ImageFile.get_board_from_filename(filename)
      image       = deployment_params[:image].read
      source_file = nil
    else
      unless deployment_params[:source_file]
        render_error :bad_request, "Specify `image' or `source_file'."
        return
      end

      board       = "esp8266" # TODO
      image       = nil
      source_file = deployment_params[:source_file].read
    end

    deployment = Deployment.new(
                   app:         @app,
                   board:       board,
                   image:       image,
                   source_file: source_file,
                   status:      (image)? "success" : "queued",
                   comment:     deployment_params[:comment],
                   tag:         deployment_params[:tag],
                   released_at: (image)? Time.now : nil
                 )

    deployment.save!
    if source_file
      deployment.build
    end
  end

  private

  def deployment_params
    params.permit(:tag, :image, :comment, :tag, :source_file)
  end
end
