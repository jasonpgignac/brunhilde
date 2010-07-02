require 'test_helper'
class InstallValidationsControllerTest < ActionController::TestCase
  def setup
    @package = packages(:office)
  end
  
  #index
  test "should get index limited to a given package" do
    get :index, {
      :package_id  => @package.id,
      :format       => "json"
    }
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:package), "parent object was not set"
    assert_equal @package, assigns(:package), "set to the wrong parent object"
    assert_not_nil assigns(:install_validations), "did not set collection"
    assert_equal @package.install_validations, assigns(:install_validations)
  end
  
  # show
  test "should get an individual ap on show" do
    get(:show, { 
      :id           => @package.install_validations.first.id,
      :package_id  => @package.id,
      :format       => "json" 
    } )
    assert_response :success, "view page was not rec'd successfully"
    assert_not_nil assigns(:package), "@package was not set"
    assert_equal @package, assigns(:package), "@package was set to the wrong system"
    assert_not_nil assigns(:install_validation), "@install_validation was not set"
    assert_equal @package.install_validations.first, assigns(:install_validation), "@install_validation was set to the wrong record"
  end
  test "should return 'record not found' on show if given an invalid id or a valid id for a different package" do
    get(:show, { 
      :id           => "Invalid ID",
      :package_id  => @package.id,
      :format       => "json" 
    } )
    assert_response :missing
    
    get(:show, { 
      :id           => install_validations(:acrobat_has_file).id,
      :package_id  => @package.id,
      :format       => "json"
    } )
    assert_response :missing
  end
  
  #create
  test "should return the install_validation and a created status on create if valid" do
    post(:create, {
      :package_id  => @package.id,
      :install_validation => {
        :package_id  => packages(:acrobat).id,
        :name           => "Test Rule",
        :rule_type      => "ExecRunning",
        :rule_parameter => "Test Data",
        :success_value  => true
      },
      :format => "json"
    })
    assert_response :created
  end
  test "should return an error on create if invalid" do
    post(:create, {
      :package_id  => @package.id,
      :install_validation => {
        :package_id  => nil
      },
      :format => "json"
    })
    assert_response :unprocessable_entity
  end
  
  # destroy
  test "should destroy the package and return a success for a destroy" do
    iv = @package.install_validations.first
    delete(:destroy, { 
        :id           => iv.id,
        :package_id  => @package.id,
        :format       => "json" 
    } )
    assert_response :success
    assert !AppliedConfiguration.exists?(iv.id)
  end
  
end