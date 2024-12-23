Rails.application.routes.draw do
  resources :medical_procedures
  resources :procedure_types
  resources :animals
  resources :animal_types
  resource :registration, only: [:new,:create]
  resource :session
  resources :passwords, param: :token
  get 'pages/about'
  get 'pages/authentification'
  get 'pages/account'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
