class BuildsController < ApplicationController
  before_action :auth
  before_action :set_app, only: [:index, :create]
  before_action :set_build, only: [:show]

  def index
    @builds = @app.builds
  end

  def create
    source_filedata = build_params[:source_file].read
    tag = build_params[:tag]

    @build = Build.new(app: @app, tag: tag, source_file: source_filedata,
                       comment: build_params[:comment])
    @build.save_and_enqueue!

    render :show, status: :accepted
  end

  def show
  end

  private

  def set_build
    set_app
    @build = Build.where(app: @app, id: params[:build_id]).first
  end

  def build_params
    params.permit(:app_name, :tag, :source_file, :comment)
  end
end
