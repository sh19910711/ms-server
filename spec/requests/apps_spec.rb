require 'rails_helper'

RSpec.describe "Apps", type: :request do
  before do
    create_and_sign_in(:chandler)
  end

  describe "GET /api/:team/apps" do
    before { api(method: 'POST', path: 'apps', data: { name: 'iot-button' }) }
    it "returns a list of applications" do
      json = api(method: 'GET', path: 'apps')
      expect(response).to have_http_status(:ok)
      expect(json['applications'].pluck('name')).to eq(['iot-button'])
    end
  end

  describe "POST /api/:team/apps" do
    context "normal" do
      it "creates a new app" do
        name = 'led-blink'
        api(method: 'POST', path: 'apps', data: { name: name })
        expect(response).to have_http_status(:ok)
        expect(App.find_by_name(name)).to be_present
      end
    end

    context "invalid name" do
      it "fails to create a new app" do
        name = '0000'
        api(method: 'POST', path: 'apps', data: { name: name })
        expect(response).to have_http_status(:unprocessable_entity)
        expect(App.find_by_name(name)).not_to be_present
      end
    end
  end

  describe "POST /api/:team/apps/:name/deployments" do
    it "deploys an app" do
      register_and_associate('my-board', 'led-blink')
      image_filepath = fixture('/sample_images/example.esp8266.image')

      expect { deploy_app('led-blink', image_filepath) }.to change(Deployment, :count).by(1)
      expect(response).to have_http_status(:ok)
    end
  end
end
