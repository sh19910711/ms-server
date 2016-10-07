require 'rails_helper'

RSpec.describe "Apps", type: :request do
  before do
    create_and_sign_in(:chandler)
  end

  describe "GET /api/:team/apps" do
    before { api('POST', 'apps', { name: 'iot_button' }) }
    it "returns a list of applications" do
      json = api('GET', 'apps')
      expect(response).to have_http_status(:ok)
      expect(json['applications'].pluck('name')).to be('iot-button')
    end
  end

  describe "POST /api/apps" do
    context "normal" do
      it "creates a new app" do
        name = 'led-blink'
        api('POST', '/api/apps', { name: name })
        expect(response).to have_http_status(:ok)
        expect(App.find_by_name(name)).to be_present
      end
    end

    context "invalid name" do
      it "fails to create a new app" do
        name = '0000'
        api('POST', '/api/apps', { name: name })
        expect(response).to have_http_status(:unprocessable_entity)
        expect(App.find_by_name(name)).not_to be_present
      end
    end
  end

  describe "POST /api/apps/:name/deployments" do
    it "deploys an app" do
      name = 'led-blink'
      # TODO: use FactoryGirl
      api('POST', '/api/apps', { name: name })
      expect(response).to have_http_status(:ok)
      expect(App.find_by_name(name)).to be_present

      # create a device
      dev_name = 'abc'
      api('PUT', "/api/devices/#{dev_name}/status", {
        board: 'esp8266',
        status: 'ready'
      })
      expect(response).to have_http_status(:ok)
      expect(Device.find_by_name(dev_name)).to be_present

      # associate the device with the app
      dev_name = 'abc'
      api('POST', "/api/apps/#{name}/devices", { device: dev_name })
      expect(response).to have_http_status(:ok)
      expect(Device.find_by_name(dev_name)).to be_present

      # deploy an image
      image_filepath = 'spec/fixtures/sample_images/esp8266.img'

      expect {
        api('POST', "/api/apps/#{name}/deployments", {
          images: [{
            board: 'esp8266',
            file: Rack::Test::UploadedFile.new(image_filepath)
          }]
        })
      }.to change(Deployment, :count).by(1)

      expect(response).to have_http_status(:ok)

      # try to download the uploaded image
      api('GET', "/api/devices/#{dev_name}/image")
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(File.open(image_filepath, 'rb').read)
    end
  end
end
