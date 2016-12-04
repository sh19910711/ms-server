require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#handle_uncaught_exception" do
    controller do
      def index
        raise IOError
      end
    end

    it "returns :internal_server_error" do
      get :index
      expect(response).to have_http_status(:internal_server_error)
    end
  end

  describe "#handle_uncaught_exception" do
    controller do
      def index
        App.find_by_name!("foo")
      end
    end

    it "returns :not_found" do
      get :index
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "#handle_validation_error" do
    controller do
      def index
        App.create!(name: "don't include white space")
      end
    end

    it "returns :unprocessable_entry" do
      get :index
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include_json(error: 'validation error')
    end
  end

  describe "#set_apps" do
    let!(:user) { create(:user) }
    let!(:app)  { create(:app, user: user) }
    before { log_in(user) }

    controller do
      before_action :set_apps
      def index
        render json: { apps: @apps.map{|a| a.slice(:name)} }
      end
    end

    it "set @apps" do
      api(:get, :index, params: { team: user.name })
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(apps: [ app.slice(:name) ])
    end
  end

  describe "#set_app" do
    let!(:user) { create(:user) }
    let!(:app)  { create(:app, user: user) }
    before { log_in(user) }

    controller do
      before_action :set_app
      def index
        render json: @app.slice(:name)
      end
    end

    it "set @app" do
      api(:get, :index, params: { team: user.name, app_name: app.name })
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(app.slice(:name))
    end
  end

  describe "#handle_api_version" do
    controller do
      def index
        head :ok
      end
    end

    context "supported API version" do
      it "does nothing" do
        request.headers['API-Version'] = API_VERSION
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.headers['API-Version']).to eq(API_VERSION)
      end
    end

    context "unsupported API version" do
      it "returns :not_acceptable" do
        request.headers['API-Version'] = API_VERSION * 2
        get :index
        expect(response).to have_http_status(:not_acceptable)
      end
    end
  end

  describe "#auth" do
    let!(:user) { create(:user) }
    before { log_in(user) }

    controller do
      before_action :auth
      def index
        render json: current_team.slice(:name)
      end
    end

    context "valid token" do
      it "set @current_team" do
        api(:get, :index, params: { team: user.name })
        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(user.slice(:name))
      end
    end

    context "invalid token" do
      it "returns :unauthorized" do
        @auth['access-token'] = 'abc'
        api(:get, :index, params: { team: user.name },
            auth: { 'access-token': '123' })
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "unauthorized team" do
      let!(:other_team) { create(:user) }

      it "returns :forbidden" do
        api(:get, :index, team: other_team.name)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
