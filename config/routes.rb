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
  
  resources :roles do
    collection do
      get 'list'
    end
    patch :apply_permission, on: :member
  end

  resources :plans, module: :client, as: :client_plans do
    collection do
      get 'list'
    end
  end

  resources :charts

  resources :clients do
    collection do
      get 'list'
    end
    resources :invoices, module: :client, only: [:index, :show] do
      patch :retry, on: :member
      resources :error_logs, module: :invoice, only: [:index, :show]
    end
  end

  namespace :reports do
    get :new_clients
    get :clients_invoiced_yesterday
    get :clients_invoiced_today
    get :clients_with_error_today
    get :clients
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "clients#index"
end
