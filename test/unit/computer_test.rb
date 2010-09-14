require 'test_helper'

class ComputerTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  test "should validate presence and uniqueness of mac address" do
    c = valid_computer
    assert c.valid?, "Was not valid with a mac address"
    c.mac_address = nil
    assert !c.valid?, "Was valid without a mac address" 
    c2 = valid_computer
    c2.save
    assert !c.valid?, "Was valid with a duplicate mac address"
    c2.destroy
  end
  test "should not save a computer without a platform" do
    c = valid_computer
    assert c.valid?, "Was invalid with a platform"
    c.platform = nil
    assert !c.valid?, "Was valid without a platform"
  end
  test "should not save a computer with an invalid platform" do
    c = valid_computer
    c.platform = "Atari"
    assert !c.valid?, "Was valid with a bad platform"
  end
  test "should validate given a valid applied_configuration_list" do
    c = computers(:default)
    c.applied_configuration_list = c.applied_configurations.map { |ac| ac.id }
    assert c.valid?, "was not valid with a valid ac_list"
  end
  test "should not validate if applied_configuration_list contains ac records that are not attached to the record" do
    c = computers(:default)
    c.applied_configuration_list = c.applied_configurations.map { |ac| ac.id }
    c.applied_configuration_list << applied_configurations(:applied_configurations_test_base).id
    assert !c.valid?, "was valid with an extra ac in the ac_list"
  end
  test "should return a list of matching, case-insensitive names on search" do
    c = valid_computer("Unique Name")
    c.save
    computers = Computer.search("Unique")
    assert computers.include?(c), "Does not include the sought item"
    assert_equal computers.size, 1, "Includes more than 1 item"
    computers = Computer.search("unique")
    assert computers.include?(c), "Does not include the sought item on case insensitive search"
    assert_equal computers.size, 1, "Includes more than 1 item on case insensitive search"
  end
  test "should return a null list if there are no matches on search" do
    computers = Computer.search("Streudelwire")
    assert_equal computers.size, 0, "Found items when it shouldn't"
  end
  test "should not validate if applied_configuration_list does not contain all the attached ac records" do
    c = computers(:default)
    c.applied_configuration_list = c.applied_configurations.map { |ac| ac.id }
    c.applied_configuration_list.shift
    assert !c.valid?, "was valid with a missing ac in the ac_list"
  end
  test "should resort applied_configurations, given a valid sort list" do
    c = computers(:default)
    old_order = c.applied_configurations.map { |ac| ac.id }
    c.applied_configuration_list = c.applied_configurations.map { |ac| ac.id }.reverse
    c.save
    assert_equal applied_configurations(:default_base).position, 2
    assert_equal applied_configurations(:default_sample_site).position, 1
  end
end