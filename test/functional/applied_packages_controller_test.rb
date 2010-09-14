require 'test_helper'

class AppliedPackagesControllerTest < ActionController::TestCase
  def setup
    @configuration = configurations(:base)
  end
  
  #index
  test "should get index limited to a given configuration" do
    get :index, {
      :configuration_id  => @configuration.id,
      :format       => "json"
    }
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:configuration), "parent object was not set"
    assert_equal @configuration, assigns(:configuration), "set to the wrong parent object"
    assert_not_nil assigns(:applied_packages), "did not set collection"
    assert_equal @configuration.applied_packages, assigns(:applied_packages)
  end
  
  # show
  test "should get an individual ap on show" do
    get(:show, { 
      :id           => @configuration.applied_packages.first.id,
      :configuration_id  => @configuration.id,
      :format       => "json" 
    } )
    assert_response :success, "view page was not rec'd successfully"
    assert_not_nil assigns(:configuration), "@configuration was not set"
    assert_equal @configuration, assigns(:configuration), "@configuration was set to the wrong system"
    assert_not_nil assigns(:applied_package), "@applied_package was not set"
    assert_equal @configuration.applied_packages.first, assigns(:applied_package), "@applied_package was set to the wrong record"
  end
  test "should return 'record not found' on show if given an invalid id or a valid id for a different configuration" do
    get(:show, { 
      :id           => "Invalid ID",
      :configuration_id  => @configuration.id,
      :format       => "json" 
    } )
    assert_response :missing
    
    get(:show, { 
      :id           => applied_packages(:sample_site_office).id,
      :configuration_id  => @configuration.id,
      :format       => "json" 
    } )
    assert_response :missing
  end
  
  #create
  test "should return the applied_package and a created status on create if valid" do
    post(:create, {
      :configuration_id  => @configuration.id,
      :applied_package => {
        :package_id  => packages(:acrobat).id
      },
      :format => "json"
    })
    assert_response :created
  end
  test "should return an error on create if invalid" do
    post(:create, {
      :configuration_id  => @configuration.id,
      :applied_package => {
        :configuration_id  => nil
      },
      :format => "json"
    })
    assert_response :unprocessable_entity
  end
  
  # destroy
  test "should destroy the configuration and return a success for a destroy" do
    conf = @configuration.applied_packages.first
    delete(:destroy, { 
        :id           => conf.id,
        :configuration_id  => @configuration.id,
        :format       => "json" 
    } )
    assert_response :success
    assert !AppliedConfiguration.exists?(conf.id)
  end
  
end