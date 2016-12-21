require 'rails_helper'


RSpec.describe AppsController, type: :controller do
  let(:user) { create(:user) }
  before { log_in(user) }

  describe 'GET index' do
    let!(:apps) { [create(:app, user: user)] }

    it 'returns a list of apps' do
      api(:get, :index)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(apps: apps.map {|a| a.slice(:name) })
    end
  end

  describe 'GET show' do
    let!(:app) { create(:app, user: user) }

    it 'returns the detail of a app' do
      api(:get, :show, params: { app_name: app.name })
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(app.slice(:name))
    end
  end

  describe 'POST create' do
    let(:name) { FFaker::Internet.domain_word }

    context 'valid app name' do
      it 'creates a new app' do
        expect do
          api(:post, :create, params: { app_name: name })
          expect(response).to have_http_status(:ok)
        end.to change { App.count }.by(1)

        app = App.find_by_name(name)
        expect(response.body).to include_json(app.slice(:name))
      end
    end

    context 'invalid app name' do
      it 'returns validation error message' do
        expect do
          api(:post, :create, params: { app_name: 'b@d name' })
          expect(response).to have_http_status(:unprocessable_entity)
        end.to change { App.count }.by(0)

        expect(response.body).to include_json(error: 'validation error')
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:app) { create(:app, user: user) }

    it 'destroys an app' do
      expect do
        api(:delete, :destroy, params: { app_name: app.name })
        expect(response).to have_http_status(:ok)
      end.to change { App.count }.by(-1)

      expect(App.where(id: app.id)).not_to exist
    end
  end

  describe 'POST add_device' do
    let(:name) { FFaker::Internet.domain_word }
    let!(:app) { create(:app, user: user) }
    let!(:device) { create(:device, user: user) }

    context "valid device" do
      it 'associates a device to an app' do
        api(:post, :add_device, params: { app_name: app.name, device_name: device.name })

        device.reload
        expect(response).to have_http_status(:ok)
        expect(device.app).to eq(app)
      end
    end

    context "invalid device" do
      it 'returns :not_found' do
        api(:post, :add_device, params: { app_name: app.name, device_name: "hogehoge" })

        device.reload
        expect(response).to have_http_status(:not_found)
        expect(response.body).to include_json(error: "No such device.")
        expect(device.app).to eq(nil)
      end
    end
  end

  describe 'GET log' do
    let(:name)  { FFaker::Internet.domain_word }
    let(:lines) { "first_line\nsecond_line\n123" }
    let!(:app)    { create(:app, user: user) }
    let!(:device) { create(:device, user: user, app: app) }

    it 'associates a device to an app' do
      device.update_status('running', lines)
      api(:get, :log, params: { app_name: app.name })
      log = JSON.parse(response.body)['log']

      expect(response).to have_http_status(:ok)
      expect(log.map {|l| l.split(':')[3] }).to eq(lines.split("\n"))
    end
  end
end
