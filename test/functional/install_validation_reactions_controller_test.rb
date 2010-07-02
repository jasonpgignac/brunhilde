require 'test_helper'
class InstallValidationReactionsControllerTest < ActionController::TestCase
  def setup
    @package = packages(:office)
    @install_validation = install_validations(:office_has_file)
  end
  
  #index
  test "should get index limited to a given install_validation" do
    get :index, {
      :package_id   => @package.id,
      :install_validation_id  => @install_validation.id,
      :format       => "json"
    }
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:package), "grandparent object was not set"
    assert_equal @package, assigns(:package), "set to the wrong grandparent object"
    assert_not_nil assigns(:install_validation), "parent object was not set"
    assert_equal @install_validation, assigns(:install_validation), "set to the wrong parent object"
    assert_not_nil assigns(:install_validation_reactions), "did not set collection"
    assert_equal @install_validation.install_validation_reactions, assigns(:install_validation_reactions)
  end
  
  # show
  test "should get an individual ap on show" do
   get(:show, { 
      :id           => @install_validation.install_validation_reactions.first.id,
      :package_id   => @package.id,
      :install_validation_id  => @install_validation.id,
      :format       => "json" 
    } )
    assert_response :success, "view page was not rec'd successfully"
    assert_not_nil assigns(:install_validation), "@install_validation was not set"
    assert_equal @install_validation, assigns(:install_validation), "@install_validation was set to the wrong system"
    assert_not_nil assigns(:install_validation_reaction), "@install_validation_reaction was not set"
    assert_equal @install_validation.install_validation_reactions.first, assigns(:install_validation_reaction), "@install_validation_reaction was set to the wrong record"
  end
  test "should return 'record not found' on show if given an invalid id or a valid id for a different install_validation" do
    get(:show, { 
      :id           => "Invalid ID",
      :package_id   => @package.id,
      :install_validation_id  => @install_validation.id,
      :format       => "json" 
    } )
    assert_response :missing
    
    get(:show, { 
      :id           => install_validation_reactions(:acrobat_has_file_error).id,
      :package_id   => @package.id,
      :install_validation_id  => @install_validation.id,
      :format       => "json"
    } )
    assert_response :missing
  end
  
  #create
  test "should return the install_validation_reaction and a created status on create if valid" do
    post(:create, {
      :install_validation_id  => @install_validation.id,
      :package_id   => @package.id,
      :install_validation_reaction => {
        :install_validation_id  => @install_validation.id,
        :command => "fatalerror",
        :parameter => "Office Word file was missing - office install failed!"
      },
      :format => "json"
    })
    assert_response :created
  end
  test "should return an error on create if invalid" do
    post(:create, {
      :install_validation_id  => @install_validation.id,
      :package_id   => @package.id,
      :install_validation_reaction => {
        :install_validation_id  => nil
      },
      :format => "json"
    })
    assert_response :unprocessable_entity
  end
  
  # destroy
  test "should destroy the install_validation and return a success for a destroy" do
    iv = @install_validation.install_validation_reactions.first
    delete(:destroy, { 
        :id           => iv.id,
        :package_id      => @package.id,
        :install_validation_id  => @install_validation.id,
        :format       => "json" 
    } )
    assert_response :success
    assert !AppliedConfiguration.exists?(iv.id)
  end
  
end