require 'rails_helper'

RSpec.describe "Apps", type: :request do
  before do
    create_and_sign_in(:chandler)
  end

  describe "GET /api/:team/apps" do
    before { api('POST', 'apps', { name: 'iot-button' }) }
    it "returns a list of applications" do
      json = api('GET', 'apps')
      expect(response).to have_http_status(:ok)
      expect(json['applications'].pluck('name')).to eq(['iot-button'])
    end
  end

  describe "POST /api/:team/apps" do
    context "normal" do
      it "creates a new app" do
        name = 'led-blink'
        api('POST', 'apps', { name: name })
        expect(response).to have_http_status(:ok)
        expect(App.find_by_name(name)).to be_present
      end
    end

    context "invalid name" do
      it "fails to create a new app" do
        name = '0000'
        api('POST', 'apps', { name: name })
        expect(response).to have_http_status(:unprocessable_entity)
        expect(App.find_by_name(name)).not_to be_present
      end
    end
  end

  describe "POST /api/:team/apps/:name/image_deployments" do
    it "deploys an app" do
      name = 'led-blink'
      # TODO: use FactoryGirl
      api('POST', 'apps', { name: name })
      expect(response).to have_http_status(:ok)
      expect(App.find_by_name(name)).to be_present

      # create a device
      device_name = 'abc'
      r = api('POST', 'devices', {
        name: device_name,
        board: 'esp8266',
        status: 'ready'
      })

      rand_id = r['rand_id']
      expect(response).to have_http_status(:ok)
      expect(Device.find_by_name(device_name)).to be_present

      api('PUT', "devices/#{rand_id}/status", {
        board: 'esp8266',
        status: 'ready'
      }, with_team_prefix=false)
      expect(response).to have_http_status(:ok)

      # associate the device with the app
      device_name = 'abc'
      api('POST', "apps/#{name}/devices", { device: rand_id })
      expect(response).to have_http_status(:ok)

      # deploy an image
      image_filepath = 'spec/fixtures/sample_images/example.esp8266.image'

      expect {
        api('POST', "apps/#{name}/image_deployments", {
          image: Rack::Test::UploadedFile.new(image_filepath)
            })
      }.to change(Deployment, :count).by(1)

      expect(response).to have_http_status(:ok)

      # try to download the uploaded image
      api('GET', "devices/#{rand_id}/image", {}, with_team_prefix=false)
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(File.open(image_filepath, 'rb').read)
    end
  end
end
