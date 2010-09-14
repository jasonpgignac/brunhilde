require 'test_helper'

class AppliedConfigurationTest < ActiveSupport::TestCase
  
  
  # Replace this with your real tests.
  test "should validate if there are valid attached objects" do
    ac = valid_applied_configuration
    assert ac.valid?, "is invalid when both objects are attached"
  end
  
  test "should not validate if there is no computer attached" do
    ac = valid_applied_configuration
    ac.computer = nil
    assert !ac.valid?, "is valid without a computer"
  end
  
  test "should not validate if there is no configuration or package attached" do
    ac = valid_applied_configuration
    ac.configuration = nil
    assert !ac.valid?, "is valid without a configuration"
  end
  
  test "should validate if there is a package attached" do
    ac = valid_applied_configuration
    ac.configuration = nil
    ac.package_id = packages(:acrobat).id
    assert ac.valid?, "is not valid with a package"
  end
  
  test "should not validate if there is a configuration and a package attached" do
    ac = valid_applied_configuration
    ac.package_id = packages(:acrobat).id
    assert !ac.valid?, "is valid with a package and configuration"
  end
  
  test "should not validate if package_id is invalid" do
    ac = valid_applied_configuration
    ac.configuration = nil
    ac.package_id = "Bad ID"
    assert !ac.valid?, "is valid with an invalid package id"
  end
  
  test "should not validate if configuration_id is invalid" do
    ac = valid_applied_configuration
    ac.configuration = nil
    ac.configuration_id = "Bad ID"
    assert !ac.valid?, "is valid with an invalid configuration id"
  end
  
  test "should not validate with an invalid package" do
    ac = valid_applied_configuration
    ac.configuration.name = nil
    assert !ac.configuration.valid?, "configuration that should be invalid is not"
    assert !ac.valid?, "is valid with an invalid configuration"
  end
  
  test "should not validate with an invalid configuration" do
    ac = valid_applied_configuration
    ac.configuration = nil
    ac.package = valid_package
    ac.package.name = nil
    assert !ac.package.valid?, "package is valid"
    assert !ac.valid?, "is valid with an invalid package"
  end
  
  test "should not validate if the platforms of the computer and configuration are not identical" do
    ac = valid_applied_configuration
    ac.configuration.platform = "Mac"
    assert !ac.valid?, "is valid with a platform mismatch between configuration and computer"
  end
  
  test "should validate if the platforms of the computer and the package match" do
    ac = valid_applied_configuration
    ac.configuration = nil
    ac.package = valid_package
    assert ac.valid?, "not valid with a package with a matching platform"
  end
  
  test "should not validate if the platforms of the computer and the package do not match" do
    ac = valid_applied_configuration
    ac.configuration = nil
    ac.package = valid_package
    ac.package.platform = "Mac"
    assert !ac.valid?, "valid with a package with a non-matching platform"
  end
  
  test "should not validate if the configuration is hosted by a different computer" do
    ac = valid_applied_configuration
    ac.configuration = valid_hosted_configuration
    assert !ac.valid?, "is valid with a configuration hosted by a different computer"
    ac.configuration = nil
  end

  test "should create a hosted configuration if a package_id is provided" do
    ac = valid_applied_configuration
    ac.configuration = nil
    ac.package = packages(:acrobat)
    ac.save
    assert ac.valid?, "ac is invalid at the end"
    assert ac.configuration, "No configuration was created"
    assert_equal ac.configuration.host_computer, ac.computer, "Configuration is not hosted"
    assert_equal ac.configuration.host_computer, ac.computer, "Wrong host computer"
    assert ac.configuration.valid?, "Config is not valid at the end"
  end
  
  test "should not validate if package_id and configuration_id are provided" do
    ac = valid_applied_configuration
    ac.package_id = packages(:acrobat).id
    assert !ac.valid?, "is valid with package and configuration set"
    ac.configuration = nil
    assert ac.valid?, "is not valid with only the package set"
  end
  
  test "should not validate if package_id is provided and computer_id is not" do
    ac = valid_applied_configuration
    ac.configuration_id = nil
    ac.package_id = packages(:acrobat).id
    ac.computer = nil
    assert !ac.valid?, "Was valid with no computer"
  end
  
  test "should return an unsaved package if it's assigned on package" do
    ac = valid_applied_configuration
    ac.configuration_id = nil
    pkg = valid_package
    ac.package = pkg
    assert_equal ac.package, pkg
  end
  
  test "should return the package referred to by package_id on package" do
    ac = valid_applied_configuration
    ac.configuration_id = nil
    ac.package_id = packages(:acrobat).id
    assert_equal ac.package, packages(:acrobat)
  end
  
  test "should return the first package in hosted configuration if there is only one package on package" do
    ac = valid_applied_configuration
    ac.configuration = nil
    pkg = valid_package
    ac.package = pkg
    ac.save
    assert ac.valid?
    assert_equal ac.package, ac.configuration.packages(:first) 
  end
  
  test "should return nil if package is not found, or no package_id, or hosted config has more than 1 package" do
    ac = valid_applied_configuration
    assert ac.package.nil?, "ac without package is returning a package"
    ac.configuration = nil
    ac.package_id = "Bad Package ID"
    assert ac.package.nil?, "ac with bad package id is returning a package"
    ac.package = valid_package
    ac.save
    ac.configuration.packages << packages(:acrobat)
    ac.configuration.save
    assert ac.package.nil?, "ac with multiple packages is returning a package"
  end
  
  test "should set the package to a given object" do
    ac = valid_applied_configuration
    ac.configuration = nil
    pkg = valid_package
    ac.package = pkg
    assert_equal ac.package, pkg
  end
  
  test "should reset the package if the package_id is set" do
    ac = valid_applied_configuration
    ac.configuration = nil
    pkg = valid_package
    ac.package = pkg
    ac.package_id = packages(:acrobat).id
    assert_equal ac.package, packages(:acrobat)
  end
end