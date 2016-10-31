require 'rails_helper'

RSpec.describe "Apps", type: :request do
  before do
    create_and_sign_in(:chandler)
  end

  describe "GET /api/:team/apps" do
    before { api(method: 'POST', path: 'apps', data: { app_name: 'iot-button' }) }
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
        api(method: 'POST', path: 'apps', data: { app_name: name })
        expect(response).to have_http_status(:ok)
        expect(App.find_by_name(name)).to be_present
      end
    end

    context "invalid name" do
      it "fails to create a new app" do
        name = '****'
        api(method: 'POST', path: 'apps', data: { app_name: name })
        expect(response).to have_http_status(:unprocessable_entity)
        expect(App.find_by_name(name)).not_to be_present
      end
    end
  end

  describe "DELETE /api/:team/apps/:app_name" do
    it "deletes a app" do
      name = 'blah-app'
      register_and_associate('foo-device', name)
      expect(App.find_by_name(name)).to be_present

      r = api(method: 'DELETE', path: "apps/#{name}")
      expect(response).to have_http_status(:ok)
      expect(App.find_by_name(name)).not_to be_present
    end
  end

  describe "POST /api/:team/apps/:name/deployments" do
    it "deploys an app" do
      register_and_associate('my-board', 'led-blink')
      image_filepath = fixture('sample-images/example.esp8266.image')

      expect { deploy_app('led-blink', image_filepath) }.to change(Deployment, :count).by(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/:team/apps/:name/builds" do
    include ActiveJob::TestHelper
    before do
      ActiveJob::Base.queue_adapter = :test
      register_and_associate('my-board', 'led-blinker')

      # ensure that docker is running
      %x[docker ps]
      unless $?.success?
        raise "Docker is not running. Use docker-machine. 2>&1"
      end
    end

    let(:valid_zip)   { fixture('sample-apps/led-blink.zip') }
    let(:invalid_zip) { fixture('sample-apps/led-blink.corrupt.zip') }

    context "valid source file" do
      it "creates a build job" do
        expect {
          api method: 'POST', path: "apps/led-blinker/builds", data: {
                source_file: Rack::Test::UploadedFile.new(valid_zip),
              }
        }.to have_enqueued_job(BuildJob).exactly(:once)

        expect(response).to have_http_status(:accepted)
      end

      it "successfully builds an app" do
        perform_enqueued_jobs do
          api method: 'POST', path: "apps/led-blinker/builds", data: {
                source_file: Rack::Test::UploadedFile.new(valid_zip),
              }

          expect(Build.order('created_at').last.status).to eq('success')
        end
      end
    end

    context "invalid source file" do
      it "fails to build an app" do
        perform_enqueued_jobs do
          api method: 'POST', path: "apps/led-blinker/builds", data: {
                source_file: Rack::Test::UploadedFile.new(invalid_zip),
              }

          expect(Build.order('created_at').last.status).to eq('failure')
        end
      end
    end
  end
end
