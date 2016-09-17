Rails.application.routes.draw do
  # Apps API
  get  'apps', to: 'apps#index'
  post 'apps', to: 'apps#create'
  post 'apps/:name/devices',     to: 'apps#add_device'
  post 'apps/:name/deployments', to: 'deployments#create'

  # Devices API
  get 'devices',  to: 'devices#index'
  put 'devices/:name/status', to: 'devices#status'
  get 'devices/:name/image',  to: 'devices#image'

  get    '*unmatched', to: proc { [400, {}, ['']] }
  put    '*unmatched', to: proc { [400, {}, ['']] }
  post   '*unmatched', to: proc { [400, {}, ['']] }
  delete '*unmatched', to: proc { [400, {}, ['']] }
end
