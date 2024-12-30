Rails.application.routes.draw do
  resources :aviaries do
    resources :sections, module: :aviaries
  end
  get '/aviaries/get_sections/:aviary_id/', to: 'aviaries#get_sections'

  resources :medical_procedures
  resources :procedure_types
  resources :animals do
    resources :notes, module: :animals
  end
  post 'animals/upload_pictures/:id', to: 'animals#upload_pictures', as: :upload_pictures
  get 'animals/delete_picture/:id', to: 'animals#delete_picture', as: :delete_picture

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
  get '/change_locale/:locale', to: 'settings#change_locale', as: :change_locale
end
