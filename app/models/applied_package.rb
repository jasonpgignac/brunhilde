class AppliedPackage < ActiveRecord::Base
  belongs_to  :package
  belongs_to  :configuration
  acts_as_list :scope => :configuration;
  
  validates_presence_of :package, :configuration
  validate :platform_matches_between_package_and_configuration
  
  private
  
  def platform_matches_between_package_and_configuration
    if package && configuration 
      unless package.platform == configuration.platform
        errors.add(:attached_items, "Package and Configuration have different platforms")
      end
    end
  end
  
end
