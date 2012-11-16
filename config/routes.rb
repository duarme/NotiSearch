Notisearch::Application.routes.draw do
  root to: 'products#index'
  
  # Users and Sessions
  resources :users 
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets
  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'
  get "password_resets/new" 
  
  #Products and Categories
  resources :categories
  resources :products     
  
  # Searches
  resources :searches do
    member do
      put :toggle_notification
    end
    collection  do
      get :notify_new_results
    end
  end
  match "/nt" => 'searches#notify_new_results' # manually triggers notification email to user   
end
