class BuildsController < ApplicationController
  before_action :auth
  before_action :set_app, only: [:create]
  before_action :set_build, only: [:log]

  def create
    source_filedata = build_params[:source_file].read
    tag = build_params[:tag]
    app = @apps.find_by_name!(build_params[:app_name])

    build = Build.new(app: app, tag: tag, source_file: source_filedata)
    build.save_and_enqueue!

    resp :accepted, { build_id: build.id }
  end

  def log
    resp :ok, { log: @build.log }
  end

  private

  def set_apps
    @apps ||= current_team.apps
  end

  def set_app
    set_apps
    @app ||= @apps.find_by_name!(params[:app_name])
  end

  def set_build
    set_app
    @build = Build.where(app: @app, id: params[:build_id]).first
  end

  def build_params
    params.permit(:app_name, :tag, :source_file)
  end
end
