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
    # The new code has 'login_failure' and 'sessions/cancel_login' routes which are additional.
    post 'login_failure', to: 'sessions#login_failure'
    # The 'login_cancel' route from the existing code seems to be a duplicate of 'sessions/cancel_login'.
    # To resolve this, we can rename the existing 'login_cancel' to something else to avoid conflict.
    # Assuming 'login_cancel' is a different action, we rename it to 'cancel_login_attempt'.
    post 'cancel_login_attempt', to: 'sessions#cancel_login' # Renamed route to avoid conflict
    post 'sessions/cancel_login', to: 'sessions#cancel_login' # Kept from new code
  end
  # ... other routes ...
end
