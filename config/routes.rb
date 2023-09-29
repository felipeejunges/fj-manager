Rails.application.routes.draw do
  # namespace :client do
  #   resources :invoices
  #   namespace :invoice do
  #     resources :error_logs
  #   end
  # end
  resources :users
  resources :clients do
    resources :invoices, module: :client do
      resources :error_logs, module: :invoice
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
