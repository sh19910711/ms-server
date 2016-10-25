def register_and_associate(device_name, app_name)
  api method: 'POST', path: 'apps', data: { app_name: app_name }
  expect(response).to have_http_status(:ok)
  expect(App.find_by_name(app_name)).to be_present

  # create a device
  r = api method: 'POST', path: 'devices', data: {
    name: device_name,
    board: 'esp8266',
    status: 'ready'
  }

  device_secret = r['device_secret']
  expect(response).to have_http_status(:ok)
  expect(Device.find_by_name(device_name)).to be_present

  api method: 'PUT', path: "devices/#{device_secret}/heartbeat?status=ready",
      with_team_prefix: false

  expect(response).to have_http_status(:ok)

  # associate the device with the app
  api method: 'POST', path: "apps/#{app_name}/devices", data: { device_name: device_name }
  expect(response).to have_http_status(:ok)

  return device_secret
end


def deploy_app(app_name, image_filepath)
  return api method: 'POST', path: "apps/#{app_name}/deployments", data: {
               image: Rack::Test::UploadedFile.new(image_filepath)
             }
end
