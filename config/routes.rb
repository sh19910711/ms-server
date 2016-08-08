Rails.application.routes.draw do
  # Apps API
  post 'apps', to: 'apps#create'
  post 'apps/:name/deployments', to: 'deployments#create'

  # Devices API
  put 'devices/:name/status', to: 'devices#status'
end
