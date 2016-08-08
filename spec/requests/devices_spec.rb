require 'rails_helper'

RSpec.describe "Devices", type: :request do
  describe "PUT /devices/:id/status" do
    it "creates a new device if it does not exist" do
      name = 'my-home-raspi'
      put "/devices/#{name}/status", params: { status: 'ready' }
      expect(response).to have_http_status(:ok)
      expect(Device.find_by_name(name)).to be_present
    end
  end
end
