require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  resources :users
  resources :clients do
    resources :invoices, module: :client, only: :show do
      patch :retry
      resources :error_logs, module: :invoice, only: :show
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
