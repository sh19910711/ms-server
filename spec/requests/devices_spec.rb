require 'rails_helper'

RSpec.describe "Devices", type: :request do
  describe "GET /devices" do
    let(:registered_device) { create(:esp8266_new_device) }
    it "returns a list of devices" do
      registered_device.save # FIXME: FactoryGirl does not save this
      r = api('GET', '/api/devices')
      expect(response).to have_http_status(:ok)
      expect(r['devices'][0]['name']).to eq(registered_device.name)
    end
  end

  describe "PUT /api/devices/:id/status" do
    let(:registered_device) { create(:esp8266_new_device) }

    context "the device exist" do
      it "updates the device status" do

        expect(registered_device.status).to eq('ready')
        api('PUT', "/api/devices/#{registered_device.name}/status", {
          board: registered_device.board,
          status: 'running'
        })

        expect(response).to have_http_status(:ok)
        registered_device.reload
        expect(registered_device.status).to eq('running')
      end
    end

    context "the device does not exist" do
      it "creates a new device" do
        name = 'my-home-esp8266'

        api('PUT', "/api/devices/#{name}/status", {
          board: 'esp8266',
          status: 'ready'
        })

        expect(response).to have_http_status(:ok)
        expect(Device.find_by_name(name)).to be_present
      end
    end
  end
end
