require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
  # ... other routes ...

  namespace :api do
    post 'login', to: 'sessions#create'
    put 'session_expiration', to: 'sessions#update_session_expiration'
    post 'login_failure', to: 'sessions#login_failure'
    # The 'cancel_login_attempt' route is a renamed version of the existing 'login_cancel' to avoid conflict.
    post 'cancel_login_attempt', to: 'sessions#cancel_login_attempt'
    # The 'sessions/cancel_login' route is kept from the new code.
    post 'sessions/cancel_login', to: 'sessions#cancel_login'
    post 'password_reset_requests', to: 'password_resets#create'
  end
  # ... other routes ...
end
