require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  let(:user) { create(:user) }
  before { log_in(user) }

  describe 'GET index' do
    let!(:devices) { [create(:device, user: user)] }

    it 'returns a list of devices' do
      api(:get, :index)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(devices: devices.map {|a| a.slice(*%i(name device_secret board tag status)) })
    end
  end

  describe 'GET show' do
    let!(:device) { create(:device, user: user) }

    it 'returns the detail of a device' do
      api(:get, :show, params: { device_name: device.name })
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(device.slice(:name))
    end
  end

  describe 'PUT update' do
    let!(:device)  { create(:device, user: user) }
    let!(:new_tag) { 'blah' }

    it 'updates the detail of a device' do
      api(:put, :update, params: { device_name: device.name, tag: new_tag })

      device.reload
      expect(response).to have_http_status(:ok)
      expect(device.tag).to eq(new_tag)
    end
  end

  describe 'POST create' do
    let(:name)  { FFaker::Internet.domain_word }
    let(:board) { 'esp8266' }

    it 'creates a new device' do
      expect do
        api(:post, :create, params: { name: name, board: board })
        expect(response).to have_http_status(:ok)
      end.to change { Device.count }.by(1)

      device = Device.find_by_name(name)
      expect(response.body).to include_json(device.slice(:name))
    end
  end

  describe 'DELETE destroy' do
    let!(:device) { create(:device, user: user) }

    it 'destroys an device' do
      expect do
        api(:delete, :destroy, params: { device_name: device.name })
        expect(response).to have_http_status(:ok)
      end.to change { Device.count }.by(-1)

      expect(Device.where(id: device.id)).not_to exist
    end
  end

  describe 'GET log' do
    let(:name)    { FFaker::Internet.domain_word }
    let(:lines)   { "first_line\nsecond_line\n123" }
    let!(:device) { create(:device, user: user) }

    it 'associates a device to an device' do
      device.update_status('running', lines)
      api(:get, :log, params: { device_name: device.name })
      log = JSON.parse(response.body)['log']

      expect(response).to have_http_status(:ok)
      expect(log.map {|l| l.split(':')[2] }).to eq(lines.split("\n"))
    end
  end

  describe 'PUT relaunch' do
    let!(:device) { create(:device, user: user) }

    it 'associates a device to an device' do
      api(:put, :relaunch, params: { device_name: device.name })

      device.reload
      expect(response).to have_http_status(:ok)
      expect(device.status).to eq('relaunch')
    end
  end
end
