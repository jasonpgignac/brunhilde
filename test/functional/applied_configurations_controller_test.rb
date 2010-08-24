require 'test_helper'

class AppliedConfigurationsControllerTest < ActionController::TestCase

  def setup
    @computer = computers(:applied_configurations_test)
  end
  
  #index
  test "should get index limited to a given computer" do
    get :index, {
      :computer_id  => @computer.id,
      :format       => "json"
    }
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:computer), "@computer was not set"
    assert_equal @computer, assigns(:computer), "@computer was set to the wrong system"
    assert_not_nil assigns(:applied_configurations), "applied_configurations#index did not set @applied_configurations"
    assert_equal @computer.applied_configurations, assigns(:applied_configurations)
  end
  
  # show
  test "should get an individual ac on show" do
    get(:show, { 
      :id           => @computer.applied_configurations.first.id,
      :computer_id  => @computer.id,
      :format       => "json" 
    } )
    assert_response :success, "view page was not rec'd successfully"
    assert_not_nil assigns(:computer), "@computer was not set"
    assert_equal @computer, assigns(:computer), "@computer was set to the wrong system"
    assert_not_nil assigns(:applied_configuration), "@applied_configuration was not set"
    assert_equal @computer.applied_configurations.first, assigns(:applied_configuration), "@applied_configuration was set to the wrong record"
  end
  test "should return 'record not found' on show if given an invalid id or a valid id for a different computer" do
    get(:show, { 
      :id           => "Invalid ID",
      :computer_id  => @computer.id,
      :format       => "json" 
    } )
    assert_response :missing
    
    get(:show, { 
      :id           => applied_configurations(:default_base).id,
      :computer_id  => @computer.id,
      :format       => "json" 
    } )
    assert_response :missing
  end

  
  #create
  test "should return the applied_configuration and a created status on create if valid" do
    post(:create, {
      :computer_id  => @computer.id,
      :applied_configuration => {
        :configuration_id  => configurations(:sample_site).id
      },
      :format => "json"
    })
    assert_response :created
  end
  test "should return an applied_configuration with a new hosted config on create if given a package" do
    post(:create, {
      :computer_id  => @computer.id,
      :applied_configuration => {
        :package_id  => packages(:acrobat).id
      },
      :format => "json"
    })
    assert_response :created
    assert assigns(:applied_configuration).configuration.host_computer
    assert_equal assigns(:applied_configuration).package, packages(:acrobat) 
  end
  test "should return an error on create if invalid" do
    post(:create, {
      :computer_id  => @computer.id,
      :applied_configuration => {
        :configuration_id  => nil
      },
      :format => "json"
    })
    assert_response :unprocessable_entity
  end
  
  # destroy
  test "should destroy the computer and return a success for a destroy" do
    conf = @computer.applied_configurations.first
    delete(:destroy, { 
        :id           => conf.id,
        :computer_id  => @computer.id,
        :format       => "json" 
    } )
    assert_response :success
    assert !AppliedConfiguration.exists?(conf.id)
  end
  
end
