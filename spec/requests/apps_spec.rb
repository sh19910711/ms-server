require 'rails_helper'

RSpec.describe "Apps", type: :request do
  describe "POST /apps" do
    it "creates a new app" do
      name = 'led-blink'
      post '/apps', params: { name: name }
      expect(response).to have_http_status(:ok)
      expect(App.find_by_name(name)).to be_present
    end
  end

  describe "POST /apps/:name/deployments" do
    it "deploys an app" do
      name = 'led-blink'
      # TODO: use FactoryGirl
      post '/apps', params: { name: name }
      expect(response).to have_http_status(:ok)
      expect(App.find_by_name(name)).to be_present

      # create a device
      dev_name = 'abc'
      put "/devices/#{dev_name}/status",
        params: { board: 'esp8266', status: 'ready' }
      expect(response).to have_http_status(:ok)
      expect(Device.find_by_name(dev_name)).to be_present

      # associate the device with the app
      dev_name = 'abc'
      post "/apps/#{name}/devices", params: { device: dev_name }
      expect(response).to have_http_status(:ok)
      expect(Device.find_by_name(dev_name)).to be_present

      # deploy an image
      image_filepath = 'spec/fixtures/sample_images/esp8266.img'
      images = [
        {
          board: 'esp8266',
          file: Rack::Test::UploadedFile.new(image_filepath)
        }
      ]

      expect {
        post "/apps/#{name}/deployments", params: { images: images }
      }.to change(Deployment, :count).by(1)

      expect(response).to have_http_status(:ok)

      # try to download the uploaded image
      get "/devices/#{dev_name}/image"
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(File.open(image_filepath, 'rb').read)
    end
  end
end
