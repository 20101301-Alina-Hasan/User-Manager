Rails.application.routes.draw do
  # Root route
  root 'home#login' # Sets the root URL of your application to the login action of the HomeController.

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'registration#new'
  post 'signup', to: 'registration#create'

  get 'index', to: 'users#index'

  resources :users do
    collection do
      patch :bulk_update
    end
  end

end

