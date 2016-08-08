Rails.application.routes.draw do
  get 'devices/:id/status', to: 'devices#status'
end
