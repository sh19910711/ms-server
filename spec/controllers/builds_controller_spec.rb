require 'rails_helper'

RSpec.describe BuildsController, type: :controller do
  let(:user) { create(:user) }
  before { log_in(user) }

  describe 'GET index' do
    let!(:app)    { create(:app, user: user) }
    let!(:builds) { [create(:build, app: app)] }

    it 'returns a list of builds' do
      api(:get, :index, params: { app_name: app.name })
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(builds: builds.map {|b| b.slice(:id, :status)})
    end
  end

  describe 'POST create' do
    let!(:app) { create(:app, user: user) }

    context 'valid zip file' do
      it 'creates and build the app successfully' do
        perform_enqueued_jobs do
          expect do
            api(:post, :create, params: {
                app_name: app.name,
                source_file: Fixture.uploaded_file('apps/led-blink.zip')
              })

            build = Build.all.last
            expect(response).to have_http_status(:accepted)
            expect(build.status).to eq('success'), "build log:\n#{build.log}"
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

            build = Build.all.last
            expect(response).to have_http_status(:accepted)
            expect(build.log).to include('failed to build')
            expect(build.status).to eq('failure'), "build log:\n#{build.log}"
          end.to change(Deployment, :count).by(0)
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

            build = Build.all.last
            expect(response).to have_http_status(:accepted)
            expect(build.log).to include('failed to build')
            expect(build.status).to eq('failure'), "build log:\n#{build.log}"
          end.to change(Deployment, :count).by(0)
        end
      end
    end
  end

  describe 'GET show' do
    let!(:app)   { create(:app, user: user) }
    let!(:build) { create(:build, app: app) }

    context 'valid build id' do
      it 'returns the details of a build' do
        api(:get, :show, params: { app_name: build.app.name, build_id: build.id })

        build.reload
        expect(response).to have_http_status(:ok)
        expect(response.body).to include_json(build.slice(:id, :status))
      end
    end

    context 'invalid build id' do
      let!(:invalid_build) { create(:build) }

      it 'returns :not_found' do
        api(:get, :show, params: { app_name: build.app.name, build_id: invalid_build.id })

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include_json(error: 'No such build.')
      end
    end
  end
end
