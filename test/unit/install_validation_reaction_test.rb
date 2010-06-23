require 'test_helper'

class InstallValidationReactionTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  test "should validate if valid" do
    vr = valid_install_validation_reaction
    assert vr.valid?
  end
  test "should validate presence of an install_validation" do
    vr = valid_install_validation_reaction
    vr.install_validation = nil
    assert !vr.valid?, "Was valid without an install_validation"
  end
  test "should validate presence and validity of a command" do
    vr = valid_install_validation_reaction
    vr.command = nil
    assert !vr.valid?, "Was valid without a command"
    vr.command = "bad_command_type"
    assert !vr.valid?, "Was valid with a bad command type"
  end
  test "should validate presence of a parameter if necessary" do
    vr = valid_install_validation_reaction
    vr.parameter = nil
    assert !vr.valid?, "Was valid without a parameter when one was needed"
    vr.command = "repeat"
    assert vr.valid?, "Was not valid without a parameter, when one was not needed"
  end

end