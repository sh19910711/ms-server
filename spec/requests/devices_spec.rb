require 'rails_helper'

RSpec.describe "Devices", type: :request do
  before do
    create_and_sign_in(:chandler)
  end

  let(:device_name) { 'my-board' }
  let(:board_name) { 'esp8266' }

  describe "GET /api/:team/devices" do
    it "returns a list of devices" do
      r = api('POST', 'devices', {
            name: device_name,
            board: board_name,
      })

      expect(r['rand_id']).to be_present

      r = api('GET', 'devices')
      expect(response).to have_http_status(:ok)
      expect(r['devices'][0]['name']).to eq(device_name)
    end
  end

  describe "PUT /api/:team/devices/:id/status" do
    it "updates the device status" do
      r = api('POST', 'devices', {
            name: device_name,
            board: board_name,
      })

      rand_id = r['rand_id']
      expect(Device.find_by_name(device_name)).to be_present
      expect(Device.find_by_name(device_name).status).to eq('new')

      api('PUT', "devices/#{rand_id}/status", {
            status: 'ready'
          })

      expect(Device.find_by_name(device_name).status).to eq('ready')

      api('PUT', "devices/#{rand_id}/status", {
            status: 'running'
          })

      expect(response).to have_http_status(:ok)
      expect(Device.find_by_name(device_name).status).to eq('running')
    end
  end
end
