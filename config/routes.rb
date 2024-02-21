
require 'sidekiq/web'
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
  # ... other routes ...

  namespace :api do
    post 'login', to: 'sessions#create'
    post 'sessions/cancel_login', to: 'sessions#cancel_login'
  end
  # ... other routes ...
end
