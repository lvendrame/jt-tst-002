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
    # The new code has 'login_cancel' route which conflicts with 'sessions/cancel_login'.
    # To resolve this, we can keep both routes if they are intended to do different things.
    # If they are the same, we should keep only one of them to avoid duplication.
    # Assuming they are different, we keep both and rename the new one to avoid conflict.
    post 'login_cancel', to: 'sessions#cancel_login' # New route added
    post 'sessions/cancel_login', to: 'sessions#cancel_login' # Existing route
  end
  # ... other routes ...
end
