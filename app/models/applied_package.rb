class AppliedPackage < ActiveRecord::Base
  belongs_to  :package
  belongs_to  :configuration
  acts_as_list :scope => :configuration;
  
end
