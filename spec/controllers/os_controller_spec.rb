require 'rails_helper'

RSpec.describe OsController, type: :controller do
  let(:device) { create(:device) }

  describe "PUT heartbeat" do
    let(:status) { 'running' }
    let(:log)    { "abc\n123\ndo re mi" }

    context "no deployments" do
      it "saves device status" do
        before_heartbeat = Time.current
        travel 3.seconds do
          device_api(:put, :heartbeat, body: log, params: {
                device_secret: device.device_secret,
                status: status,
              })
        end

        device.reload
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('X')
        expect(device.status).to eq(status)
        expect(device.heartbeated_at).to be > before_heartbeat
      end
    end

    context "a deployment exist" do
      let!(:app)        { create(:app) }
      let!(:device)     { create(:device, app: app) }
      let!(:deployment) { create(:deployment, app: app) }

      it "saves device status" do
        before_heartbeat = Time.now
        device_api(:put, :heartbeat, body: log, params: {
              device_secret: device.device_secret,
              status: status,
            })

        device.reload
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(deployment.id.to_s)
        expect(device.status).to eq(status)
        expect(device.heartbeated_at).to be > before_heartbeat
      end
    end
  end

  describe "GET image" do
    let!(:app)        { create(:app) }
    let!(:device)     { create(:device, app: app) }
    let!(:deployment) { create(:deployment, app: app) }

    it "returns the deployed app image" do
      device_api(:get, :image, params: {
            device_secret: device.device_secret,
            deployment_id: deployment.id,
          })

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(deployment.image)
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
