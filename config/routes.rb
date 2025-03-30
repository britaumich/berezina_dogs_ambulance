Rails.application.routes.draw do
  resources :admin_users, except: [:show]
  get 'cart', to: 'cart#show'
  post 'cart/add'
  post 'cart/remove'
  post 'empty_cart/:id', to: 'cart#empty_cart', as: :empty_cart
  post 'add_medical_procedure', to: 'cart#add_medical_procedure'
  post 'add_completed_medical_procedure', to: 'cart#add_completed_medical_procedure'
  post 'add_to_aviary', to: 'cart#add_to_aviary'
  resources :aviaries do
    resources :sections, module: :aviaries
  end
  get '/aviaries/get_sections/:aviary_id/', to: 'aviaries#get_sections'

  resources :notes
  resources :medical_procedures do
    resources :notes, module: :medical_procedures
  end
  get '/new_medical_procedure_for_animal/:animal_id/', to: 'medical_procedures#new_medical_procedure_for_animal', as: :new_medical_procedure_for_animal
  get '/edit_medical_procedure_for_animal/:procedure_id/', to: 'medical_procedures#edit_medical_procedure_for_animal', as: :edit_medical_procedure_for_animal

  resources :procedure_types, except: [:show]
  resources :animals do
    resources :notes, module: :animals
  end
  post 'animals/upload_pictures/:id', to: 'animals#upload_pictures', as: :upload_pictures
  get 'animals/delete_picture/:id', to: 'animals#delete_picture', as: :delete_picture
  post 'animals/delete_medical_procedure/:id/:procedure_id', to: 'animals#delete_medical_procedure', as: :delete_medical_procedure
  get 'animals/duplicate/:id', to: 'animals#duplicate', as: :duplicate

  resources :animal_types, except: [:show] 
  resources :animal_statuses,  except: [:show] 
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
