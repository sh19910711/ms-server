class DeploymentsController < ApplicationController
  def create

    deployment = Deployment.new
    deployment.app = App.find_by_name(deployment_params[:name])
    deployment.tag = deployment_params[:tag]

    images = Array(deployment_params[:images]).map do |img|
      image = Image.new
      image.deployment = deployment
      image.board = img['board']
      image.file = img['file']
      image
    end

    ActiveRecord::Base.transaction do
      images.each do |image|
        image.save!
      end
      deployment.save!
    end

    head :ok
  end

  private

  def deployment_params
    params.permit(:name, :tag, images: [:board, :file])
  end
end
