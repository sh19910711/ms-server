require 'rails_helper'

RSpec.describe "Devices", type: :request do
  before do
    create_and_sign_in(:chandler)
  end

  let(:device_name) { 'my-board' }
  let(:board_name) { 'esp8266' }

  describe "GET /api/:team/devices" do
    it "returns a list of devices" do
      r = api(method: 'POST', path: 'devices', data: {
            name: device_name,
            board: board_name,
      })

      expect(r['device_secret']).to be_present

      r = api method: 'GET', path: 'devices'
      expect(response).to have_http_status(:ok)
      expect(r['devices'][0]['name']).to eq(device_name)
    end
  end

  describe "PUT /api/devices/:device_secret/heartbeat" do
    it "updates the device status" do
      r = api(method: 'POST', path: 'devices', data: {
            name: device_name,
            board: board_name,
      })

      device_secret = r['device_secret']
      expect(Device.find_by_name(device_name)).to be_present
      device = Device.find_by_name(device_name)
      expect(device.status.value).to eq('new')

      api(method: 'PUT', path: "devices/#{device_secret}/heartbeat?status=ready",
          with_team_prefix: false)

      expect(device.status.value).to eq('ready')

      api(method: 'PUT', path: "devices/#{device_secret}/heartbeat?status=running",
          with_team_prefix: false)

      expect(response).to have_http_status(:ok)
      expect(device.status.value).to eq('running')
    end
  end

  describe "GET /api/devices/:device_secret/image" do
    before(:each) do
      @image_filepath = fixture('sample-images/example.esp8266.image')
    end

    def deploy_it
      @device_secret = register_and_associate('my-board', 'led-blinker')
      deploy_app('led-blinker', @image_filepath)

      # TODO
      Deployment.where(app: App.find_by_name!('led-blinker')).order('created_at').last.id
    end

    def download_image(deployment_id=nil, range=nil)
        api(method: 'GET', path: "devices/#{@device_secret}/image",
            data: { deployment_id: deployment_id },
            headers: { Range: range }, with_team_prefix: false)
    end

    context "deployment id is not speicified" do
      it "returns the latest deployment app image" do
        deploy_it()
        download_image()
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(File.open(@image_filepath, 'rb').read)
        # TODO: check that the deployment is the latest one
      end
    end

    context "deployment id is speicified" do
      it "returns the specified app image" do
        deployment_id = deploy_it()
        download_image(deployment_id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(File.open(@image_filepath, 'rb').read)
      end

      it "returns :not_found if the specified deployment does not exist" do
        device_secret = register_and_associate('my-board', 'led-blinker')
        api(method: 'GET', path: "devices/#{device_secret}/image",
            data: { deployment_id: 1 }, with_team_prefix: false)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "valid Range is speicified" do
      it "returns the partial content" do
        deployment_id = deploy_it()
        download_image(deployment_id,'bytes=7-9')
        expect(response).to have_http_status(:partial_content)
        expect(response.body).to eq(IO.binread(@image_filepath, 3, 7))
      end
    end

    context "invalid Range is speicified" do
      it "returns :bad_request" do
        deployment_id = deploy_it()

        download_image(deployment_id,'bytes=123234-16')
        expect(response).to have_http_status(:bad_request)

        download_image(deployment_id,'bytes=-123234-16')
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "GET /api/:team/devices/:device_name/logging" do
    it "returns logging" do
      device_secret = register_and_associate('iot-button', 'led-blinker')

      lines = ['Hello', 'World!']
      api(method: 'PUT', path: "devices/#{device_secret}/heartbeat?status=running",
          data: lines.join("\n"), with_team_prefix: false)

      expect(response).to have_http_status(:ok)

      r = api(method: 'GET', path: "devices/iot-button/log")
      lines.each_with_index do |l, i|
        expect(r['log'][i].split(':')[1]).to eq(l)
      end
    end
  end
end
