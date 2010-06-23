require 'test_helper'

class ComputersControllerTest < ActionController::TestCase
  # index
  test "should get index" do
    get :index
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:computers), "computers#index did not set @computers"
    assert assigns(:computers).count == Computer.all.count, "computers#index did not return all computers"
  end
  test "should get a searched subset of index" do
    assert false, "Test not yet implemented"
  end
  
  # show
  test "should get and individual computer on show" do
    get(:show, { :id => Computer.first.id })
    assert_response :success, "view page was not rec'd successfully"
    assert_not_nil assigns(:computer), "did not set @computer"
    assert assigns(:computer) == (Computer.first), "did not set @computer to the requested object"
  end

  test "should return 'record not found' on show if given an invalid id" do
    get(:show, { :id => "INVALID ID"})
    assert_response :missing
  end
  
  # new
  test "should create a new computer on new" do
    get :new
    assert_response :success, "new computer page was not rec'd successfully"
    assert_not_nil assigns(:computer), "did not make a new computer"
    assert assigns(:computer).new_record?, "returned a saved computer instead of a new one"
  end

  # edit
  test "should get and individual computer on edit" do
    get(:edit, { :id => Computer.first.id })
    assert_response :success, "edit page was not rec'd successfully"
    assert_not_nil assigns(:computer), "did not set @computer"
    assert assigns(:computer) == (Computer.first), "did not set @computer to the requested object"
  end
  
  test "should return 'record not found' on edit if given an invalid id" do
    get(:edit, { :id => "INVALID ID"})
    assert_response :missing
  end
  
  # create
  test "should create a computer and redirect to show for a valid computer" do
    post(:create, {
      :computer => {
        :mac_address  => "Valid New Computer",
        :platform     => "PC"
      }
    })
    
    assert_response :redirect
    assert_redirected_to assigns(:computer)
    
    assert assigns(:computer)
    assert !assigns(:computer).new_record?
    assert assigns(:computer).mac_address == "Valid New Computer"
    
    assert flash[:notice] == 'Computer was successfully created.'
  end
  
  test "should not create a computer, shoudl render edit with errors and field values if computer is invalid" do
    post(:create, {
      :computer => {
        :mac_address  => "Invalid New Computer"
      }
    })
    assert_response :success
    assert assigns(:computer)
    assert assigns(:computer).new_record?
    assert_equal "Invalid New Computer", assigns(:computer).mac_address
    assert assigns(:computer).errors.size > 0
  end
  
  test "should return the computer and a created status in xml on create if valid" do
    post(:create, {
      :computer => {
        :mac_address  => "Another Valid New Computer",
        :platform     => "PC"
      },
      :format => "xml"
    })
    assert_response :created
  end
  
  test "should return an error in xml on create if invalid" do
    post(:create, {
      :computer => {
        :mac_address  => "Invalid New Computer"
      },
      :format   => "xml"
    })
    assert_response :unprocessable_entity
  end
  
  #update
  test "should update the computer, and redirect with a flash to show for a valid update" do
    computer = Computer.create(
      :mac_address  => "Valid Existing Computer",
      :platform     => "PC")
    put(:update, {
      :id => computer.id,
      :computer => {
        :mac_address    => "Valid Updated Computer"
      }
    })
    
    assert_response :redirect
    assert_redirected_to assigns(:computer)
    
    assert assigns(:computer)
    assert !assigns(:computer).changed?
    assert assigns(:computer).mac_address == "Valid Updated Computer"
    
    assert flash[:notice] == 'Computer was successfully updated.'
  end
  
  test "should display edit, along with any errors, for an invalid update" do
    computer = Computer.create(
      :mac_address  => "Another Valid Existing Computer",
      :platform     => "PC")
    put(:update, {
      :id       => computer.id,
      :computer => {
        :mac_address  => "Invalid New Computer",
        :platform     => nil
      }
    })
    assert_response :success
    assert assigns(:computer)
    assert assigns(:computer).changed?
    assert_equal "Invalid New Computer", assigns(:computer).mac_address
    assert assigns(:computer).errors.size > 0
  end
  
  test "should a successful status on an xml valid update" do
    computer = Computer.create(
      :mac_address  => "A 3rd Valid Existing Computer",
      :platform     => "PC")
    put(:update, {
      :id       => computer.id,
      :computer => {
        :mac_address  => "A 3rd updated Computer"
      },
      :format => "xml"
    })
    assert_response :success
  end
  
  test "should return an errors status on an xml invalid update" do
    computer = Computer.create(
      :mac_address  => "A 4th Valid Existing Computer",
      :platform     => "PC")
    put(:update, {
      :id       => computer.id,
      :computer => {
        :mac_address  => "A 4th updated Computer",
        :platform     => nil
      },
      :format => "xml"
    })
    assert_response :unprocessable_entity
  end
  
  test "should sort applied_configurations if submitted" do
    put(:update, {
      :id       => computers(:default),
      :computer => {
        :applied_configuration_list => [
          applied_configurations(:default_sample_site).id,
          applied_configurations(:default_base).id
        ]
      }
    })
    assert_response :redirect
    assert_redirected_to assigns(:computer)
    assert applied_configurations(:default_base).reload.position > applied_configurations(:default_sample_site).reload.position
  end
  
  # destroy
  test "should destroy the computer and redirect to index with a flash for a destroy" do
    computer = Computer.create(
      :mac_address  => "Computer to Destroy",
      :platform     => "PC")
      
    delete(:destroy, {:id => computer.id})
    
    assert_response :redirect
    assert_redirected_to computers_path
    assert_equal 'Computer was successfully destroyed', flash[:notice]
    assert !Computer.exists?(computer.id)
  end
end
