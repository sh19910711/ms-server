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

  describe "PUT /api/devices/:id/status" do
    it "updates the device status" do
      r = api(method: 'POST', path: 'devices', data: {
            name: device_name,
            board: board_name,
      })

      device_secret = r['device_secret']
      expect(Device.find_by_name(device_name)).to be_present
      expect(Device.find_by_name(device_name).status).to eq('new')

      api(method: 'PUT', path: "devices/#{device_secret}/status", data: {
            status: 'ready'
          }, with_team_prefix: false)

      expect(Device.find_by_name(device_name).status).to eq('ready')

      api(method: 'PUT', path: "devices/#{device_secret}/status", data: {
            status: 'running'
          }, with_team_prefix: false)

      expect(response).to have_http_status(:ok)
      expect(Device.find_by_name(device_name).status).to eq('running')
    end
  end

  describe "GET /api/devices/:device_secret/image" do
    it "returns app images" do
      image_filepath = fixture('sample_images/example.esp8266.image')
      device_secret = register_and_associate('my-board', 'led-blinker')
      deploy_app('led-blinker', image_filepath)

      api(method: 'GET', path: "devices/#{device_secret}/image", with_team_prefix: false)
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(File.open(image_filepath, 'rb').read)
    end

    it "supports Range header" do
      image_filepath = fixture('sample_images/example.esp8266.image')
      device_secret = register_and_associate('my-board', 'led-blinker')
      deploy_app('led-blinker', image_filepath)

      api(method: 'GET', path: "devices/#{device_secret}/image", headers: {
            'Range': 'bytes=7-16'
          }, with_team_prefix: false)
      expect(response).to have_http_status(:partial_content)
      expect(response.body).to eq(IO.binread(image_filepath, 9, 7))
    end
  end
end
