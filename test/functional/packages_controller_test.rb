require 'test_helper'

class PackagesControllerTest < ActionController::TestCase
  # index
  test "should get index" do
    get :index
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:packages), "index did not set collection"
    assert_equal assigns(:packages).count, Package.all.count, "index did not return all records"
  end
  
  test "should get a searched subset of index" do
    p = valid_package("Trilobyte Pancake 2.3")
    p.save
    get :index, {:query => "Trilobyte"}
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:packages), "index did not set collection"
    assert_equal assigns(:packages).count, 1, "index did not return 1 record"
    assert_equal assigns(:packages)[0], p, "index returned the wrong record"
    assert_equal assigns(:query), "Trilobyte", "query was not set"
  end
  
  # show
  test "should get an individual record on show" do
    get(:show, { :id => Package.first.id })
    assert_response :success, "view page was not rec'd successfully"
    assert_not_nil assigns(:package), "did not set instance"
    assert assigns(:package) == (Package.first), "did not set instance to the requested object"
  end

  test "should return 'record not found' on show if given an invalid id" do
    get(:show, { :id => "INVALID ID"})
    assert_response :missing
  end
  # new
   test "should create a new instance on new" do
     get :new
     assert_response :success, "new page was not rec'd successfully"
     assert_not_nil assigns(:package), "did not make a new instance"
     assert assigns(:package).new_record?, "returned a saved instance instead of a new one"
   end

   # edit
   test "should get an individual record on edit" do
     get(:edit, { :id => Package.first.id })
     assert_response :success, "edit page was not rec'd successfully"
     assert_not_nil assigns(:package), "did not set instance"
     assert assigns(:package) == (Package.first), "did not set instance to the requested object"
   end

   test "should return 'record not found' on edit if given an invalid id" do
     get(:edit, { :id => "INVALID ID"})
     assert_response :missing
   end
   
   # create
   test "should create a record and redirect to show for a valid record" do
     post(:create, {
       :package => valid_package_hash("Valid New Package")
     }
     )

     assert_response :redirect
     assert_redirected_to assigns(:package)

     assert assigns(:package)
     assert !assigns(:package).new_record?
     assert_equal assigns(:package).name, "Valid New Package"

     assert_equal flash[:notice], 'Package was successfully created.'
   end

   test "should not create a record, should render edit with errors and field values if record is invalid" do
     ph = valid_package_hash("Invalid New Package")
     ph[:platform] = nil
     post(:create, {
       :package => ph
     })
     assert_response :success
     assert assigns(:package)
     assert assigns(:package).new_record?
     assert_equal "Invalid New Package", assigns(:package).name
     assert assigns(:package).errors.size > 0
   end

   test "should return the record and a created status in xml on create if valid" do
     post(:create, {
       :package => valid_package_hash("Yet Another Valid package"),
       :format => "xml"
     })
     assert_response :created
   end

   test "should return an error in xml on create if invalid" do
     ph = valid_package_hash("Invalid New Package Again")
     ph.shift
     post(:create, {
       :package => ph,
       :format   => "xml"
     })
     assert_response :unprocessable_entity
   end

   #update
   test "should update the record, and redirect with a flash to show for a valid update" do
     package = valid_package("Valid Existing Package")
     package.save
     put(:update, {
       :id => package.id,
       :package => {
         :name    => "Valid Updated Package"
       }
     })

     assert_response :redirect
     assert_redirected_to assigns(:package)

     assert assigns(:package)
     assert !assigns(:package).changed?
     assert_equal assigns(:package).name, "Valid Updated Package"

     assert_equal flash[:notice], 'Package was successfully updated.'
   end

   test "should display edit, along with any errors, for an invalid update" do
     package = valid_package("Another Valid Existing Package")
     package.save
     put(:update, {
       :id       => package.id,
       :package => {
         :name      => "Invalid New Package",
         :platform  => nil
       }
     })
     assert_response :success
     assert assigns(:package)
     assert assigns(:package).changed?
     assert_equal "Invalid New Package", assigns(:package).name
     assert assigns(:package).errors.size > 0
   end

   test "should return a successful status on an xml valid update" do
     package = valid_package("A 3rd Valid Existing Package")
     package.save
     put(:update, {
       :id       => package.id,
       :package => {
         :name  => "A 3rd updated Package"
       },
       :format => "xml"
     })
     assert_response :success
   end

   test "should return an errors status on an xml invalid update" do
     package = valid_package "A 4th Valid Existing Package"
     package.save
     put(:update, {
       :id       => package.id,
       :package => {
         :name      => "A 4th updated Package",
         :platform  => nil
       },
       :format => "xml"
     })
     assert_response :unprocessable_entity
   end

   # destroy
   test "should destroy the record and redirect to index with a flash for a destroy" do
     package = valid_package "Package to Destroy"
     package.save
     delete(:destroy, {:id => package.id})

     assert_response :redirect
     assert_redirected_to packages_path
     assert_equal 'Package was successfully destroyed', flash[:notice]
     assert !Package.exists?(package.id)
   end
  
end