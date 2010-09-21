Brunhilde::Application.routes.draw do |map|
  resources :computers do
    member do
      post :sort
      post :add_package
      post :add_configuration
      post :remove_configuration
    end
    resources :applied_configurations
  end

  resources :configurations do
    member do
      post :sort
      post :add_package
      post :remove_package
    end
    resources :applied_packages
  end
  resources :packages do
    resources :install_validations do
      resources :install_validation_reactions
    end
  end
  resources :user_sessions
  resources :users
  match ':controller/:action/:id.:format'
  match "login" => "user_sessions#new"
  match "logout" => "user_sessions#destroy"
end
