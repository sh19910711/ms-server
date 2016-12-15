Rails.application.routes.draw do
  scope :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    # Apps API
    get    '/:team/apps',                       to: 'apps#index'
    post   '/:team/apps',                       to: 'apps#create'
    get    '/:team/apps/:app_name',             to: 'apps#show'
    delete '/:team/apps/:app_name',             to: 'apps#destroy'
    post   '/:team/apps/:app_name/devices',     to: 'apps#add_device'
    get    '/:team/apps/:app_name/log',         to: 'apps#log'
    get    '/:team/apps/:app_name/deployments', to: 'deployments#index'
    get    '/:team/apps/:app_name/deployments/:major', to: 'deployments#show'
    post   '/:team/apps/:app_name/deployments', to: 'deployments#create'

    post   '/:team/apps/:app_name/builds',      to: 'builds#create'
    get    '/:team/apps/:app_name/builds',      to: 'builds#index'
    get    '/:team/apps/:app_name/builds/:build_id', to: 'builds#show'

    # Devices API
    get    '/:team/devices',                            to: 'devices#index'
    post   '/:team/devices',                            to: 'devices#create'
    get    '/:team/devices/:device_name',               to: 'devices#show'
    put    '/:team/devices/:device_name',               to: 'devices#update'
    delete '/:team/devices/:device_name',               to: 'devices#destroy'
    put    '/:team/devices/:device_name/relaunch',      to: 'devices#relaunch'
    get    '/:team/devices/:device_name/log',           to: 'devices#log'
    get    '/:team/devices/:device_name/envvars',       to: 'envvars#index'
    put    '/:team/devices/:device_name/envvars/:name', to: 'envvars#update'
    delete '/:team/devices/:device_name/envvars/:name', to: 'envvars#destroy'

    # API for MakeStack OS
    put  '/devices/:device_secret/heartbeat', to: 'os#heartbeat'
    get  '/devices/:device_secret/image',     to: 'os#image'
    get  '/devices/:device_secret/envvars',   to: 'os#envvars'
  end
end
