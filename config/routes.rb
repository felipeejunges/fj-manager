require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  get 'login' => 'user_sessions#login'
  post 'login' => 'user_sessions#authenticate'
  get 'logout' => 'user_sessions#logout'

  resources :users do
    collection do
      get 'list'
    end
  end
  resources :clients do
    collection do
      get 'list'
    end
    resources :invoices, module: :client, only: [:index, :show] do
      patch :retry, on: :member
      resources :old_error_logs, module: :invoice, only: [:index, :show]
      resources :error_logs, module: :invoice, only: [:index, :show]
    end
  end

  namespace :reports do
    get :new_clients
    get :clients_invoiced_yesterday
    get :clients
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "clients#index"
end
