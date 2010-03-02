authorization do
  role :admin do
    includes :package_admin, :image_admin, :configuration_admin
  end
  
  role :package_admin do
    has_permission_on [:packages], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:imaging_access], :to => [:prescript, :postscript, :first_boot_script]
  end
  role :image_admin do
    has_permission_on [:computers], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:imaging_access], :to => [:prescript, :postscript, :first_boot_script]
  end
  role :configuration_admin do
    has_permission_on [:configurations], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:imaging_access], :to => [:prescript, :postscript, :first_boot_script]
  end
  
  role :packager do
    has_permission_on [:packages], :to => [:index, :show, :new, :create]
    has_permission_on [:packages] do
      to [:edit, :update, :destroy]
      if_attribute :owner_id => is {user.id}
    end
    has_permission_on [:imaging_access], :to => [:prescript, :postscript, :first_boot_script]
  end
  role :configurator do
    has_permission_on [:configurations], :to => [:index, :show, :new, :create]
    has_permission_on [:configurations] do
      to [:edit, :update, :destroy]
      if_attribute :owner_id => is {user.id}
    end
    has_permission_on [:imaging_access], :to => [:prescript, :postscript, :first_boot_script]
  end
  role :image_creator do
    has_permission_on [:computers], :to => [:index, :show, :new, :create]
    has_permission_on [:computers] do
      to [:edit, :update, :destroy]
      if_attribute :owner_id => is {user.id}
    end
    has_permission_on [:imaging_access], :to => [:prescript, :postscript, :first_boot_script]
  end
  role :guest do
    has_permission_on [:imaging_access], :to => [:prescript, :postscript, :first_boot_script]
  end
end
