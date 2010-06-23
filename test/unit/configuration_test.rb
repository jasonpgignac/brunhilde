require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  test "should validate presence and uniqueness of name" do
    c = valid_configuration
    assert c.valid?, "Was not valid with a name"
    c.name = nil
    assert !c.valid?, "Was valid without a name" 
    c2 = valid_configuration
    c2.save
    assert !c.valid?, "Was valid with a duplicate name"
    c2.destroy
  end
  test "should validate presence of platform" do
    c = valid_configuration
    assert c.valid?, "Was invalid with a platform"
    c.platform = nil
    assert !c.valid?, "Was valid without a platform"
  end
  test "should validate that it is related to the host_computer if defined, and no other computers" do
    c = valid_hosted_configuration
    assert c.valid?, "Was not valid with correct hosted computer relationship"
    c.host_computer = valid_computer("wrong host computer")
    assert !c.valid?, "was valid with the wrong host computer"
    c.computers = []
    assert !c.valid?, "was valid when unrelated to it's host computer"
    c = valid_hosted_configuration
    c.computers << valid_computer("extra related computer")
    assert !c.valid?, "was valid when hosted and related to more than 1 computer"
  end
  test "should not save a computer with an invalid platform" do
    c = valid_configuration
    assert c.valid?, "Was invalid with a platform"
    c.platform = "Atari"
    assert !c.valid?, "Was valid without a platform"
  end
  test "should validate given a valid applied_package_list" do
    c = configurations(:base)
    c.applied_package_list = c.applied_packages.map { |ap| ap.id }
    assert c.valid?, "was not valid with a valid ap_list"
  end
  test "should not validate if applied_package_list contains ac records that are not attached" do
    c = configurations(:base)
    c.applied_package_list = c.applied_packages.map { |ap| ap.id }
    c.applied_package_list << applied_packages(:sample_site_office)
    assert !c.valid?, "was valid with an extra ap in the ap_list"
  end
  test "should not validate if applied_package_list does not contain all the attached ap records" do
    c = configurations(:base)
    c.applied_package_list = c.applied_packages.map { |ap| ap.id }
    c.applied_package_list.shift
    assert !c.valid?, "was valid with a missing ap in the ap_list"
  end
  test "should not validate if there are stage 0 items after stage 1 items" do
    c = configurations(:base)
    ap = applied_packages(:base_image)
    ap.position = 3
    ap.save
    c.reload
    assert !c.valid?, "was valid with a stage 0 object after stage 1"
  end
  test "should resort applied_packages, given a valid sort list" do
    c = configurations(:base)
    ap_list = [
      applied_packages(:base_image).id,
      applied_packages(:base_office).id,
      applied_packages(:base_acrobat).id
    ]
    c.applied_package_list = ap_list
    c.save
    assert_equal 0, applied_packages(:base_image).reload.position, "Image is not at 0"
    assert_equal 1, applied_packages(:base_office).reload.position, "Office install did not move"
    assert_equal 2, applied_packages(:base_acrobat).reload.position, "Acrobat install did not move"
  end
  test "should not validate if there are stage 0 items after stage 1 items in the sort list" do
    c = configurations(:base)
    ap_list = [
      applied_packages(:base_acrobat).id,
      applied_packages(:base_image).id,
      applied_packages(:base_office).id
    ]
    c.applied_package_list = ap_list
    assert !c.valid?, "was valid with a stage 0 object after stage 1"
  end
end