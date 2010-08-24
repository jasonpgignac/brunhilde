require 'test_helper'

class InstallValidationTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  test "should validate if valid" do
    iv = valid_install_validation
    assert iv.valid?
  end
  test "should validate presence of a package" do
    iv = valid_install_validation
    iv.package = nil
    assert !iv.valid?, "Was valid without a package"
  end
  test "should validate presence of a description" do
    iv = valid_install_validation
    iv.description = nil
    assert !iv.valid?, "Was valid without a name"
  end
  test "should validate presence of a rule_type, and that it is in the ruleset" do
    iv = valid_install_validation
    iv.rule_type = nil
    assert !iv.valid?, "Was valid without a rule_type"
    iv.rule_type = "InvalidTestType"
    assert !iv.valid?, "Was valid with an invalid rule_type"
  end
  test "should validate presence of a rule_parameter if necessary" do
    iv = valid_install_validation
    iv.rule_parameter = nil
    assert !iv.valid?, "Was valid without a rule_parameter"
  end
  test "should validate presence of a success_value" do
    iv = valid_install_validation
    iv.success_value = nil
    assert !iv.valid?, "Was valid without a success_value"
  end
end