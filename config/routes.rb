Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: %w(omniauth_callbacks)
  post 'auth/request', to: 'requests/authorization'
end
