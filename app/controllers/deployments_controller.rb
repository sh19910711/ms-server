class DeploymentsController < ApplicationController
  def create

    deployment = Deployment.new
    deployment.app = App.find_by_name(deployment_params[:name])

    images = deployment_params[:images].map do |image|
      image = Image.new
      image.deployment = deployment
      image.board = image['board']
      image.file = image['file']
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
    params.permit(:name, images: [{}])
  end
end
