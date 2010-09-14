class AppliedConfiguration < ActiveRecord::Base
  belongs_to  :computer
  belongs_to  :configuration
  acts_as_list :scope => :computer
  
  validates_presence_of :computer
  validate :contains_valid_package_id_or_valid_configuration_id
  validate :platform_matches
  validate :configuration_is_not_hosted_by_another_computer
  
  after_save :convert_package_to_hosted_configuration, :if => :waiting_for_package_conversion?
  attr_accessor :package_id
  
  def package
    return @package if @package
    return Package.find(package_id) if package_id && Package.exists?(package_id)
    return self.configuration.packages(:first) if self.configuration && self.configuration.host_computer && self.configuration.packages.size == 1
    return nil
  end
  def package_id=(p_id)
    @package_id = p_id
    @package = nil
  end
  def package=(pkg)
    if pkg.is_a?(Package)
      @package = pkg
      package_id = @package.id
    elsif pkg.nil?
      @package = nil
      package_id = nil
    else
      raise RuntimeError, "Expected a Package object"
    end 
  end  
    
  private
  def waiting_for_package_conversion?
    return true if self.package && !self.configuration
    return false
  end
  def pending_package
    return @package if @package
    return Package.find(package_id) if package_id && Package.exists?(package_id)
    return nil
  end
  def convert_package_to_hosted_configuration
    @package.save if @package
    Package.find(package_id).save if package_id && Package.exists?(package_id)
    configuration = Configuration.new(:name => "Hosted #{id} (#{package.name})")
    configuration.platform = package.platform
    configuration.packages << package
    configuration.host_computer = self.computer
    configuration.save(:validate => false)
    self.package = nil
    self.configuration = configuration
    self.save(:validate => false)
  end
  def platform_matches
    if computer && configuration 
      unless computer.platform == configuration.platform
        errors.add(:attached_items, "Computer and Configuration have different platforms")
      end
    elsif computer && pending_package
      unless computer.platform == package.platform
        errors.add(:attached_items, "Computer and Package have different platforms")
      end
    end
  end
  def configuration_is_not_hosted_by_another_computer
    if configuration && configuration.host_computer
      unless configuration.host_computer == computer
        errors.add(:configuration, "Configuration is hosted by a different computer")
      end
    end
  end
  def contains_valid_package_id_or_valid_configuration_id
    errors.add(:configuration, "Cannot select both a configuration and a package") if configuration && pending_package
    if configuration_id
      errors.add(:configuration, "Configuration does not exist") unless configuration
    elsif package_id
      errors.add(:configuration, "Package does not exist") unless package
    elsif !configuration && !package
      errors.add(:configuration, "Must select a configuration or a package")
    end 
  end
end
