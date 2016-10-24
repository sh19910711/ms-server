require 'rails_helper'

RSpec.describe "Envvars", type: :request do
  before do
    create_and_sign_in(:chandler)
  end

  describe "GET /api/devices/:device_secret/envvars" do
    it "returns all envvars" do
      register_and_associate('my-board', 'led-blinker')
      api(method: 'GET', path: "devices/my-board/envvars")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/devices/:device_secret/envvars/:name" do
    it "creates and updates a envvar" do
      register_and_associate('my-board', 'led-blinker')
      device = Device.find_by_name!('my-board')

      api(method: 'PUT', path: "devices/my-board/envvars/FOO_BAR",
          data: { value: '123' })

      expect(response).to have_http_status(:ok)
      expect(Envvar.where(device: device, name: 'FOO_BAR').first.value).to eq('123')

      api(method: 'PUT', path: "devices/my-board/envvars/FOO_BAR",
          data: { value: 'new one' })

      expect(response).to have_http_status(:ok)
      expect(Envvar.where(device: device, name: 'FOO_BAR').first.value).to eq('new one')
      end
  end


  describe "DELETE /api/devices/:device_secret/envvars/:name" do
    it "removes an envvar" do
      register_and_associate('my-board', 'led-blinker')
      device = Device.find_by_name!('my-board')

      api(method: 'PUT', path: "devices/my-board/envvars/FOO_BAR",
          data: { value: '123' })

      expect(response).to have_http_status(:ok)
      expect(Envvar.where(device: device, name: 'FOO_BAR').first.value).to eq('123')

      api(method: 'DELETE', path: "devices/my-board/envvars/FOO_BAR")

      expect(response).to have_http_status(:ok)
      expect(Envvar.where(device: device, name: 'FOO_BAR')).not_to exist
      end
  end
end
