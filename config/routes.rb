Rails.application.routes.draw do
  scope :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    # Apps API
    get  '/:user/apps',                   to: 'apps#index'
    post '/:user/apps',                   to: 'apps#create'
    post '/:user/apps/:name/devices',     to: 'apps#add_device'
    post '/:user/apps/:name/deployments', to: 'deployments#create'

    # Devices API
    get '/:user/devices',              to: 'devices#index'
    put '/:user/devices/:name/status', to: 'devices#status'
    get '/:user/devices/:name/image',  to: 'devices#image'

    get    '*unmatched', to: proc { [400, {}, ['']] }
    put    '*unmatched', to: proc { [400, {}, ['']] }
    post   '*unmatched', to: proc { [400, {}, ['']] }
    delete '*unmatched', to: proc { [400, {}, ['']] }
  end
end
