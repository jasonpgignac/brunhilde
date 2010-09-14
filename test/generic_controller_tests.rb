module GenericControllerTests
  # index
  test "should get index" do
    get :index
    assert_response :success, "index page was not rec'd successfully"
    assert_not_nil assigns(:packages), "index did not set collection"
    assert_equal assigns(:packages).count, Package.all.count, "index did not return all records"
  end

  test "should get a searched subset of index" do
    assert false, "Test not yet implemented"
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
end