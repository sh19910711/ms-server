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
end
