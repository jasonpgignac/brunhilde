class PackagesController < ApplicationController
  before_filter :set_current_tab
  
  # GET /packages
  # GET /packages.xml
  def index
    if params[:query]
      @packages = Package.search(params[:query])
    else
      @packages = Package.find(:all)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @packages }
    end
  end

  # GET /packages/1
  # GET /packages/1.xml
  def show
    @package = Package.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package }
    end
  end

  # GET /packages/new
  # GET /packages/new.xml
  def new
    @package = Package.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @package }
    end
  end

  # GET /packages/1/edit
  def edit
    @package = Package.find(params[:id])
  end

  # POST /packages
  # POST /packages.xml
  def create
    @package = Package.new(params[:package])
    @package.owner = current_user
    respond_to do |format|
      if @package.save
        flash[:notice] = 'Package was successfully created.'
        format.html { redirect_to(@package) }
        format.xml  { render :xml => @package, :status => :created, :location => @package }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /packages/1
  # PUT /packages/1.xml
  def update
    @package = Package.find(params[:id])

    respond_to do |format|
      if @package.update_attributes(params[:package])
        flash[:notice] = 'Package was successfully updated.'
        format.html { redirect_to(@package) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.xml
  def destroy
    @package = Package.find(params[:id])
    @package.destroy

    respond_to do |format|
      flash[:notice] = "Package was successfully destroyed"
      format.html { redirect_to(packages_url) }
      format.xml  { head :ok }
    end
  end

  private
    def set_current_tab
      @current_tab = "packages"
    end
end
