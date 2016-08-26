require 'rails_helper'

RSpec.describe "Devices", type: :request do
  describe "PUT /devices/:id/status" do
    let(:registered_device) { create(:esp8266_new_device) }

    context "the device exist" do
      it "updates the device status" do

        expect(registered_device.status).to eq('ready')
        put "/devices/#{registered_device.name}/status", params: {
              board: registered_device.board,
              status: 'running'
            }
        expect(response).to have_http_status(:ok)
        registered_device.reload
        expect(registered_device.status).to eq('running')
      end
    end

    context "the device does not exist" do
      it "creates a new device" do
        name = 'my-home-esp8266'
        params = {
          board: 'esp8266',
          status: 'ready'
        }
        put "/devices/#{name}/status", params: params
        expect(response).to have_http_status(:ok)
        expect(Device.find_by_name(name)).to be_present
      end
    end
  end
end
