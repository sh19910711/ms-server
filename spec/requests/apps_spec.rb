require 'rails_helper'

RSpec.describe "Apps", type: :request do
  describe "POST /apps" do
    it "creates a new app" do
      name = 'led-blink'
      post '/apps', params: { name: name }
      expect(response).to have_http_status(:ok)
      expect(App.find_by_name(name)).to be_present
    end
  end

  describe "POST /apps/:name/deployments" do
    it "deploys an app" do
      name = 'led-blink'
      # TODO: use FactoryGirl
      post '/apps', params: { name: name }
      expect(response).to have_http_status(:ok)
      expect(App.find_by_name(name)).to be_present

      images = [
        {
          board: 'esp8266',
          file: File.open('spec/requests/sample_images/esp8266.img')
        }
      ]

      expect {
        post "/apps/#{name}/deployments", params: { images: images }
      }.to change(Deployment, :count).by(1)

      expect(response).to have_http_status(:ok)
    end
  end
end
