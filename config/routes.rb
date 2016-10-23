Rails.application.routes.draw do
  scope :api do
    mount_devise_token_auth_for 'User', at: 'auth'

    # Apps API
    get  '/:team/apps',                       to: 'apps#index'
    post '/:team/apps',                       to: 'apps#create'
    post '/:team/apps/:app_name/devices',     to: 'apps#add_device'
    post '/:team/apps/:app_name/builds',      to: 'apps#build'
    post '/:team/apps/:app_name/deployments', to: 'apps#deploy'

    # Devices API
    get  '/:team/devices', to: 'devices#index'
    post '/:team/devices', to: 'devices#create'
    put  '/:team/devices/:device_name', to: 'devices#update'
    put  '/devices/:device_secret/heartbeat', to: 'baseos#heartbeat'
    get  '/devices/:device_secret/image',  to: 'baseos#image'
  end
end
