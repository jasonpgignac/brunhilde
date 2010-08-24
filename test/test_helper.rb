ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def valid_computer(mac="12345678")
    Computer.new(:mac_address => mac, :platform => "PC")
  end
  def valid_configuration(name="Test Configuration")
    Configuration.new(:name => name, :platform => "PC")
  end
  def valid_hosted_configuration
    host = valid_computer("host_computer")
    c = Configuration.new(:name => "Hosted Configuration", :platform => "PC", :host_computer => valid_computer("host_computer"))
    c.computers << c.host_computer
    return c
  end
  def valid_package(name="Brunhilde")
    Package.new(
      :name => name, 
      :source_path => "stitchbound/#{name}",
      :deployment_stage => "1",
      :executable => "install.bat", 
      :platform => "PC")
  end
  def valid_package_hash(name="Brunhilde")
    {
      :name => name, 
      :source_path => "stitchbound/#{name}",
      :deployment_stage => "1",
      :executable => "install.bat", 
      :platform => "PC"
    }
  end
  def valid_install_validation
    InstallValidation.new(
      :package        => valid_package,
      :description    => "Test Rule",
      :rule_type      => "ExecRunning",
      :rule_parameter => "Test Data",
      :success_value  => true)
  end
  def unattached_install_validation_reaction
    InstallValidationReaction.new(
      :command      => "wait",
      :parameter    => "30",
      :repetitions  => 3)
  end
  def valid_install_validation_reaction
    vr = unattached_install_validation_reaction
    vr.install_validation = valid_install_validation
    return vr
  end
  def valid_applied_configuration
    AppliedConfiguration.new(:configuration => valid_configuration, :computer => valid_computer)
  end
  
end
