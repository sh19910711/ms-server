require 'rails_helper'

RSpec.describe OsController, type: :controller do
  let(:device) { create(:device) }

  describe "PUT heartbeat" do
    let(:status) { 'running' }
    let(:log)    { "abc\n123\ndo re mi" }

    context "no deployments" do
      it "saves device status" do
        device_api(:put, :heartbeat, body: log, params: {
              device_secret: device.device_secret,
              status: status,
            })

        device.reload
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('X')
        expect(device.status).to eq(status)
        expect(device.heartbeated_at).not_to eq(nil)
      end
    end

    context "a deployment exist" do
      let!(:app)        { create(:app) }
      let!(:device)     { create(:device, app: app) }
      let!(:deployment) { create(:deployment, app: app) }

      it "saves device status" do
        device_api(:put, :heartbeat, body: log, params: {
              device_secret: device.device_secret,
              status: status,
            })

        device.reload
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(deployment.id.to_s)
        expect(device.status).to eq(status)
        expect(device.heartbeated_at).not_to eq(nil)
      end
    end

    context "relaunching requested" do
      let!(:app)        { create(:app) }
      let!(:device)     { create(:device, app: app, status: 'relaunch') }

      it "saves device status" do
        device_api(:put, :heartbeat, body: log, params: {
              device_secret: device.device_secret,
              status: status,
            })

        device.reload
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('R')
        expect(device.status).to eq(status)
        expect(device.heartbeated_at).not_to eq(nil)
      end
    end

    context "invalid device_secret" do
      it "return :forbidden" do
        device_api(:put, :heartbeat, body: log, params: {
              device_secret: 'invalid_device_secret',
              status: status,
            })

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET image" do
    let!(:app)        { create(:app) }
    let!(:device)     { create(:device, app: app) }
    let!(:deployment) { create(:deployment, app: app) }

    context "without Range header" do
      it "returns the deployed app image" do
        device_api(:get, :image, params: {
              device_secret: device.device_secret,
              deployment_id: deployment.id,
            })

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(deployment.image)
      end
    end

    context "with valid Range header" do
      it "returns a part of a deployed app image" do
        device_api(:get, :image, params: {
              device_secret: device.device_secret,
              deployment_id: deployment.id,
            }, headers: { range: 'bytes=2-5' })

        expect(response).to have_http_status(:partial_content)
        expect(response.body).to eq(deployment.image[2..5])
      end
    end

    context "with invalid Range header" do
      it "returns :bad_request" do
        device_api(:get, :image, params: {
              device_secret: device.device_secret,
              deployment_id: deployment.id,
            }, headers: { range: "2-5" })

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid Range header (offset_end > filesize)" do
      it "returns :bad_request" do
        device_api(:get, :image, params: {
              device_secret: device.device_secret,
              deployment_id: deployment.id,
            }, headers: { range: "bytes=#{deployment.image.size + 1}-" })

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with invalid Range header (offset_end < offset)" do
      it "returns :bad_request" do
        device_api(:get, :image, params: {
              device_secret: device.device_secret,
              deployment_id: deployment.id,
            }, headers: { range: "bytes=5-2" })

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "GET envvars" do
    let!(:device)  { create(:device) }
    let!(:envvars) { [ create(:envvar, device: device), create(:envvar, device: device) ] }
    let(:response_body) {
      envvars.map{|e| "#{e.name}=#{e.value}"}.join("\x04") + "\x04device_name=#{device.name}"
    }

    it "returns all envvars" do
      device_api(:get, :envvars, params: {
            device_secret: device.device_secret,
          })

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(response_body)
    end
  end
end
