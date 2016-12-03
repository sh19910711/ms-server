class BuildsController < ApplicationController
  before_action :auth
  before_action :set_app, only: [:index, :create, :show]

  def index
    @builds = @app.builds
  end

  def create
    source_filedata = build_params[:source_file].read
    tag = build_params[:tag]

    @build = Build.new(app: @app, tag: tag, source_file: source_filedata,
                       status: 'queued', comment: build_params[:comment])
    @build.save_and_enqueue!

    render :show, status: :accepted
  end

  def show
    @build = Build.where(app: @app, id: params[:build_id]).first
    unless @build
      render_error :not_found, "No such build."
      return
    end
  end

  private

  def build_params
    params.permit(:app_name, :tag, :source_file, :comment)
  end
end
