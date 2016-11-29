class BuildsController < ApplicationController
  before_action :auth
  before_action :set_app, only: [:index, :create]
  before_action :set_build, only: [:show]

  def index
    resp :ok, { builds: Build.where(app: @app).select(:id, :status, :created_at).all }
  end

  def create
    source_filedata = build_params[:source_file].read
    tag = build_params[:tag]
    app = @apps.find_by_name!(build_params[:app_name])

    build = Build.new(app: app, tag: tag, source_file: source_filedata,
                      comment: build_params[:comment])
    build.save_and_enqueue!

    resp :accepted, { id: build.id }
  end

  def show
    resp :ok, @build.slice(:id, :log, :created_at, :status, :tag)
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
