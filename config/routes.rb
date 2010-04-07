ActionController::Routing::Routes.draw do |map|
  map.resources :computers, :collection => { :sort => :post, :add_package => :post }

  map.resources :configurations, :collection => { :sort => :post, :add_package => :post }

  map.resources :packages do |package|
    package.resources :tests, :controller => :package_tests do |test|
      test.resources :reactions, :controller => :package_test_reactions
    end
  end
  map.resources :applied_packages # INCOMPLETE - Limit to available functions
  map.resources :package_test_reactions
  map.resources :user_sessions
  map.resources :users
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
