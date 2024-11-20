Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  #User
  get '/users' => "users#index"
  post '/users' => "users#create"
  get 'users/current' => 'users#show'
  delete '/users/:id' => "users#destroy"

  #Activity
  get '/activities' => 'activities#index'
  get '/activities/:id' => 'activities#show'
  post '/activities' => 'activities#create'
  patch '/activities/:id'=> 'activities#update'
  delete '/activities/:id' => 'activities#destroy'

  #Sessions 
  post '/sessions' => 'sessions#create'

  #Categories 
  get '/categories' => 'categories#index'
  get '/categories/:id' => 'categories#show'
  post '/categories' => 'categories#create'
  patch '/categories/:id' => 'categories#update'
  delete '/categories/:id' => 'categories#destroy'
  
  # Defines the root path route ("/")
  # root "posts#index"
  root "homepages#index"

  get '/homepages' => "homepages#index"

  get '*path', to: 'react#index', constraints: ->(req) do
    !req.xhr? && req.format.html? && !req.path.start_with?('/assets/', '/favicon', '/robots.txt')
  end
end
