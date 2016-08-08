Rails.application.routes.draw do
  put 'devices/:name/status', to: 'devices#status'
end
