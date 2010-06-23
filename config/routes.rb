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
    resources :tests do
      resources :reactions
    end
  end
  resources :package_test_reactions
  resources :user_sessions
  resources :users
  match "login" => "user_sessions#new"
  match "logout" => "user_sessions#destroy"
end
