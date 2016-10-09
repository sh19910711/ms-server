Rails.application.routes.draw do
  scope :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    # Apps API
    get  '/:team/apps',                   to: 'apps#index'
    post '/:team/apps',                   to: 'apps#create'
    post '/:team/apps/:name/devices',     to: 'apps#add_device'
    post '/:team/apps/:name/deployments', to: 'apps#deploy_image'

    # Devices API
    get  '/:team/devices', to: 'devices#index'
    post '/:team/devices', to: 'devices#create'
    put '/:team/devices/:device_rand_id/status', to: 'devices#status'
    get '/:team/devices/:device_rand_id/image',  to: 'devices#image'

    get    '*unmatched', to: proc { [400, {}, ['']] }
    put    '*unmatched', to: proc { [400, {}, ['']] }
    post   '*unmatched', to: proc { [400, {}, ['']] }
    delete '*unmatched', to: proc { [400, {}, ['']] }
  end
end
