require 'rails_helper'

RSpec.describe EnvvarsController, type: :controller do
  let(:user) { create(:user) }
  before { log_in(user) }

  describe "GET index" do
    let!(:device)  { create(:device, user: user) }
    let!(:envvars) { [create(:envvar, device: device)] }

    it "returns all envvars" do
      api(:get, :index, params: { device_name: device.name })
      expect(response).to have_http_status(:ok)
      expect(response.body).to include_json(envvars: envvars.map {|e| e.slice(*%i(name value)) })
    end
  end

  describe "PUT update" do
    let!(:device)   { create(:device, user: user) }
    let(:name)      { 'HELLO' }
    let(:value)     { 'world' }
    let(:new_value) { 'universe' }

    it "creates and updates a envvar" do
      api(:put, :update, params: {
            device_name: device.name,
            name: name,
            value: value
          })

      var = Envvar.where(device: device, name: name).first
      expect(response).to have_http_status(:ok)
      expect(var.value).to eq(value)

      api(:put, :update, params: {
            device_name: device.name,
            name: name,
            value: new_value
          })

      var.reload
      expect(response).to have_http_status(:ok)
      expect(var.value).to eq(new_value)
    end
  end


  describe "DELETE destroy" do
    let!(:device){ create(:device, user: user) }
    let!(:var)   { create(:envvar, device: device) }

    context "envvar which exists" do
      it "removes an envvar" do
        api(:delete, :destroy, params: {
              device_name: device.name,
              name: var.name
            })

        expect(response).to have_http_status(:ok)
        expect(Envvar.where(device: device, name: var.name)).not_to exist
      end
    end

    context "envvar that it does not exist" do
      it "returns :not_found" do
        api(:delete, :destroy, params: {
              device_name: device.name,
              name: 'FOO'
            })

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include_json(error: 'No such envvar.')
      end
    end
  end
end
