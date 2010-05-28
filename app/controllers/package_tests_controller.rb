class PackageTestsController < ApplicationController
  before_filter :set_current_tab
  before_filter :atify_package
  # GET /package_tests
  # GET /package_tests.xml
  def index
    @packages = PackageTest.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @package_tests }
    end
  end

  # GET /package_tests/1
  # GET /package_tests/1.xml
  def show
    @package_test = PackageTest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package_test }
    end
  end

  # GET /package_tests/new
  # GET /package_tests/new.xml
  def new
    @package_test = PackageTest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @package_test }
    end
  end

  # GET /package_tests/1/edit
  def edit
    @package_test = PackageTest.find(params[:id])
  end

  # POST /package_tests
  # POST /package_tests.xml
  def create
    @package_test = PackageTest.new(params[:package_test])
    @package_test.package_id = @package.id
    respond_to do |format|
      if @package_test.save
        flash[:notice] = 'PackageTest was successfully created.'
        format.html { redirect_to(package_test_path(@package, @package_test)) }
        format.xml  { render :xml => @package_test, :status => :created, :location => package_tests_path(@package, @package_test.id) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package_test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /package_tests/1
  # PUT /package_tests/1.xml
  def update
    @package_test = PackageTest.find(params[:id])

    respond_to do |format|
      if @package_test.update_attributes(params[:package_test])
        flash[:notice] = 'PackageTest was successfully updated.'
        format.html { redirect_to(@package) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package_test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /package_tests/1
  # DELETE /package_tests/1.xml
  def destroy
    @package_test = PackageTest.find(params[:id])
    @package_test.destroy

    respond_to do |format|
      format.html { redirect_to(@package) }
      format.xml  { head :ok }
    end
  end

  private
  def set_current_tab
    @current_tab = "packages"
  end
  def atify_package
    @package = Package.find(params[:package_id])
  end
end
