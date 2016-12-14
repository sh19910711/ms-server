require 'rails_helper'

RSpec.describe DeploymentsController, type: :controller do
  let(:user) { create(:user) }
  before { log_in(user) }

  describe 'GET index' do
    let!(:app)         { create(:app, user: user) }
    let!(:deployments) { [create(:deployment, app: app)] }

    it 'returns a list of deployments' do
      api(:get, :index, params: { app_name: app.name })
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(deployments: deployments.map {|d|
                                              d.slice(*%i(tag board major_version minor_version comment))
                                           })
    end
  end

  describe 'POST create' do
    let!(:app)         { create(:app, user: user) }
    let!(:deployments) { [create(:deployment, app: app)] }

    it 'creates a new deployment' do
      expect do
        api(:post, :create, params: {
              app_name: app.name,
              image: Fixture.uploaded_file('apps/hello.esp8266.image')
            })

        expect(response).to have_http_status(:ok)
      end.to change { Deployment.count }.by(1)
    end
  end
end
