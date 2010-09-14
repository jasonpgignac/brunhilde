require 'test_helper'

class AppliedPackageTest < ActiveSupport::TestCase
  
  def valid_applied_package
    AppliedPackage.new(:configuration => valid_configuration, :package => valid_package)
  end
  
  # Replace this with your real tests.
  test "should validate if there are valid attached objects" do
    ap = valid_applied_package
    assert ap.valid?, "is invalid when both objects are attached"
  end
  
  test "should not validate if there is no package attached" do
    ap = valid_applied_package
    ap.package = nil
    assert !ap.valid?, "is valid without a package"
  end
  
  test "should not validate if there is no configuration attached" do
    ap = valid_applied_package
    ap.configuration = nil
    assert !ap.valid?, "is valid without a configuration"
  end
  
  test "should not validate if the platforms of the package and configuration are not identical" do
    ap = valid_applied_package
    ap.configuration.platform = "Mac"
    assert !ap.valid?, "is valid with a platform mismatch between configuration and computer"
  end
end