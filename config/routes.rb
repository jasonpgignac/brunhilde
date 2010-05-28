Brunhilde::Application.routes.draw do |map|
  resources :computers do
    collection do
      post :sort
      post :add_package
    end
  end

  resources :configurations do
    collection do
      post :sort
      post :add_package
    end
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
