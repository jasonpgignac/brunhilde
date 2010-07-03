require 'test_helper'

class ConfigurationsControllerTest < ActionController::TestCase
  # index
  test "should get index" do
    get :index
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:configurations), "index did not set @configurations"
    assert_equal assigns(:configurations).count, Configuration.all.count, "index did not return all configs"
  end
  
  test "should get a searched subset of index" do
    c = valid_configuration("Proust Questionnaire Eeelslippers")
    c.save
    get :index, {:query => "Eelslippers"}
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:configurations), "index did not set collection"
    assert_equal assigns(:configurations).count, 1, "index did not return 1 record"
    assert_equal assigns(:configurations)[0], c, "index returned the wrong record"
    assert_equal assigns(:query), "Eelslippers", "query was not set"
  end
  
  # show
  test "should get an individual record on show" do
    get(:show, { :id => Configuration.first.id })
    assert_response :success, "view page was not rec'd successfully"
    assert_not_nil assigns(:configuration), "did not set instance"
    assert assigns(:configuration) == (Configuration.first), "did not set instance to the requested object"
  end

  test "should return 'record not found' on show if given an invalid id" do
    get(:show, { :id => "INVALID ID"})
    assert_response :missing
  end
  # new
   test "should create a new instance on new" do
     get :new
     assert_response :success, "new page was not rec'd successfully"
     assert_not_nil assigns(:configuration), "did not make a new instance"
     assert assigns(:configuration).new_record?, "returned a saved instance instead of a new one"
   end

   # edit
   test "should get an individual record on edit" do
     get(:edit, { :id => Configuration.first.id })
     assert_response :success, "edit page was not rec'd successfully"
     assert_not_nil assigns(:configuration), "did not set instance"
     assert assigns(:configuration) == (Configuration.first), "did not set instance to the requested object"
   end

   test "should return 'record not found' on edit if given an invalid id" do
     get(:edit, { :id => "INVALID ID"})
     assert_response :missing
   end
   
   # create
   test "should create a record and redirect to show for a valid record" do
     post(:create, {
       :configuration => {
         :name      => "Valid New Configuration",
         :platform  => "PC"
       }
     })

     assert_response :redirect
     assert_redirected_to assigns(:configuration)

     assert assigns(:configuration)
     assert !assigns(:configuration).new_record?
     assert_equal assigns(:configuration).name, "Valid New Configuration"

     assert_equal flash[:notice], 'Configuration was successfully created.'
   end

   test "should not create a record, should render edit with errors and field values if record is invalid" do
     post(:create, {
       :configuration => {
         :name  => "Invalid New Configuration"
       }
     })
     assert_response :success
     assert assigns(:configuration)
     assert assigns(:configuration).new_record?
     assert_equal "Invalid New Configuration", assigns(:configuration).name
     assert assigns(:configuration).errors.size > 0
   end

   test "should return the record and a created status in xml on create if valid" do
     post(:create, {
       :configuration => {
         :name  => "Another Valid New Conf",
         :platform     => "PC"
       },
       :format => "xml"
     })
     assert_response :created
   end

   test "should return an error in xml on create if invalid" do
     post(:create, {
       :configuration => {
         :name  => "Invalid New Conf"
       },
       :format   => "xml"
     })
     assert_response :unprocessable_entity
   end

   #update
   test "should update the record, and redirect with a flash to show for a valid update" do
     configuration = Configuration.create(
       :name      => "Valid Existing Configuration",
       :platform  => "PC")
     put(:update, {
       :id => configuration.id,
       :configuration => {
         :name    => "Valid Updated Configuration"
       }
     })

     assert_response :redirect
     assert_redirected_to assigns(:configuration)

     assert assigns(:configuration)
     assert !assigns(:configuration).changed?
     assert_equal assigns(:configuration).name, "Valid Updated Configuration"

     assert_equal flash[:notice], 'Configuration was successfully updated.'
   end

   test "should display edit, along with any errors, for an invalid update" do
     configuration = Configuration.create(
       :name      => "Another Valid Existing Configuration",
       :platform  => "PC")
     put(:update, {
       :id       => configuration.id,
       :configuration => {
         :name      => "Invalid New Configuration",
         :platform  => nil
       }
     })
     assert_response :success
     assert assigns(:configuration)
     assert assigns(:configuration).changed?
     assert_equal "Invalid New Configuration", assigns(:configuration).name
     assert assigns(:configuration).errors.size > 0
   end

   test "should return a successful status on an xml valid update" do
     configuration = Configuration.create(
       :name      => "A 3rd Valid Existing Configuration",
       :platform  => "PC")
     put(:update, {
       :id       => configuration.id,
       :configuration => {
         :name  => "A 3rd updated Configuration"
       },
       :format => "xml"
     })
     assert_response :success
   end

   test "should return an errors status on an xml invalid update" do
     configuration = Configuration.create(
       :name      => "A 4th Valid Existing Configuration",
       :platform  => "PC")
     put(:update, {
       :id       => configuration.id,
       :configuration => {
         :name      => "A 4th updated Configuration",
         :platform  => nil
       },
       :format => "xml"
     })
     assert_response :unprocessable_entity
   end

   test "should sort applied_configurations if submitted" do
     put(:update, {
       :id       => configurations(:base).id,
       :configuration => {
         :applied_package_list => [
           applied_packages(:base_image).id,
           applied_packages(:base_office).id,
           applied_packages(:base_acrobat).id
         ]
       }
     })
     assert_response :redirect
     assert_redirected_to assigns(:configuration)
     assert applied_packages(:base_acrobat).reload.position > applied_packages(:base_office).reload.position
   end

   # destroy
   test "should destroy the record and redirect to index with a flash for a destroy" do
     config = Configuration.create(
       :name      => "Configuration to Destroy",
       :platform  => "PC")

     delete(:destroy, {:id => config.id})

     assert_response :redirect
     assert_redirected_to configurations_path
     assert_equal 'Configuration was successfully destroyed', flash[:notice]
     assert !Configuration.exists?(config.id)
   end
   
end
