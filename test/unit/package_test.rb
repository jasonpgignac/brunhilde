require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  
  
  # Replace this with your real tests.
  test "shoudl validate with all fields present" do
    p = valid_package
    assert p.valid?, "was not valid with all the right fields defined"
  end
  test "should validate presence of name" do
    p = valid_package
    p.name = nil
    assert !p.valid?, "Was valid without a name"
  end
  test "should validate presence of source_path, deployment_stage and executable" do
    p = valid_package
    p.source_path = nil
    assert !p.valid?, "Was valid without a source_path"
    p = valid_package
    p.deployment_stage = nil
    assert !p.valid?, "Was valid without a deployment_stage"
    p = valid_package
    p.executable = nil
    assert !p.valid?, "Was valid without an executable"
  end
  test "should validate presence of platform" do
    p = valid_package
    p.platform = nil
    assert !p.valid?, "Was valid without a platform"
  end
  
  test "should not save a package with an invalid platform" do
    p = valid_package
    p.platform = "Atari"
    assert !p.valid?, "Was valid with a bad platform"
  end
  
  test "should not save a package with an invalid deployment_stage" do
    p = valid_package
    p.deployment_stage = 3
    assert !p.valid?, "Was valid with a bad deployment stage"
  end
  
  test "should return a list of matching, case-insensitive names on search" do
    p = valid_package("Unique Name")
    p.save
    packages = Package.search("Unique")
    assert packages.include?(p), "Does not include the sought item"
    assert_equal packages.size, 1, "Includes more than 1 item"
    packages = Package.search("unique")
    assert packages.include?(p), "Does not include the sought item on case insensitive search"
    assert_equal packages.size, 1, "Includes more than 1 item on case insensitive search"
  end
  test "should return a null list if there are no matches on search" do
    packages = Package.search("Streudelwire")
    assert_equal packages.size, 0, "Found packages when it shouldn't"
  end
end