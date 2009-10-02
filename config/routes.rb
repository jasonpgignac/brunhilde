ActionController::Routing::Routes.draw do |map|
  map.resources :computers, :collection => { :sort => :post, :add_package => :post }

  map.resources :configurations, :collection => { :sort => :post, :add_package => :post }

  map.resources :packages do |package|
    package.resources :tests, :controller => :package_tests do |test|
      test.resources :reactions, :controller => :package_test_reactions
    end
  end
  map.resources :package_test_reactions

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
