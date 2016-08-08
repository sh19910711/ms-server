Rails.application.routes.draw do
  # Apps API
  post 'apps', to: 'apps#create'
  post 'apps/:name/devices',     to: 'apps#add_device'
  post 'apps/:name/deployments', to: 'deployments#create'

  # Devices API
  put 'devices/:name/status', to: 'devices#status'
  get 'devices/:name/image',  to: 'devices#image'
end
