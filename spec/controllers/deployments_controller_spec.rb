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
                                              d.slice(*%i(tag board status buildlog version comment))
                                           })
    end
  end

  describe 'POST create' do
    let!(:app)         { create(:app, user: user) }
    let!(:devices)     { [create(:device, user: user, app: app)] }
    let!(:deployments) { [create(:deployment, app: app)] }

    context 'valid zip file' do
      it 'creates and build the app successfully' do
        perform_enqueued_jobs do
          expect do
            api(:post, :create, params: {
                app_name: app.name,
                source_file: Fixture.uploaded_file('apps/led-blink.zip')
              })

            deployment = Deployment.all.last
            expect(response).to have_http_status(:ok)
            expect(deployment.status).to eq('success'), "build log:\n#{deployment.buildlog}"
          end.to change(Deployment, :count).by(1)
        end
      end
    end

    context 'invalid zip file' do
      it 'fails to build' do
        perform_enqueued_jobs do
          expect do
            api(:post, :create, params: {
                app_name: app.name,
                source_file: Fixture.uploaded_file('apps/led-blink/application.yaml')
              })

            deployment = Deployment.all.last
            expect(response).to have_http_status(:ok)
            expect(deployment.buildlog).to include('failed to build')
            expect(deployment.status).to eq('failure'), "build log:\n#{deployment.buildlog}"
          end.to change(Deployment, :count).by(1)
        end
      end
    end

    context 'invalid zip file' do
      it 'fails to build' do
        perform_enqueued_jobs do
          expect do
            api(:post, :create, params: {
                app_name: app.name,
                source_file: Fixture.uploaded_file('apps/broken.zip')
              })

            deployment = Deployment.all.last
            expect(response).to have_http_status(:ok)
            expect(deployment.buildlog).to include('failed to build')
            expect(deployment.status).to eq('failure'), "build log:\n#{deployment.buildlog}"
          end.to change(Deployment, :count).by(1)
        end
      end
    end

    it 'deploys a pre-built image file' do
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
