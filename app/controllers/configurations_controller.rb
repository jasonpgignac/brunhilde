class ConfigurationsController < ApplicationController
  before_filter :set_current_tab
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  
  # GET /configurations
  # GET /configurations.xml
  def index
    @configurations = Configuration.find_all_by_host_computer_id(nil)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @configurations }
    end
  end

  # GET /configurations/1
  # GET /configurations/1.xml
  def show
    @configuration = Configuration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @configuration }
    end
  end

  # GET /configurations/new
  # GET /configurations/new.xml
  def new
    @configuration = Configuration.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @configuration }
    end
  end

  # GET /configurations/1/edit
  def edit
    @configuration = Configuration.find(params[:id])
  end

  # POST /configurations
  # POST /configurations.xml
  def create
    @configuration = Configuration.new(params[:configuration])
    @configuration.owner = current_user
    respond_to do |format|
      if @configuration.save
        flash[:notice] = 'Configuration was successfully created.'
        format.html { redirect_to(@configuration) }
        format.xml  { render :xml => @configuration, :status => :created, :location => @configuration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @configuration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /configurations/1
  # PUT /configurations/1.xml
  def update
    @configuration = Configuration.find(params[:id])

    respond_to do |format|
      if @configuration.update_attributes(params[:configuration])
        flash[:notice] = 'Configuration was successfully updated.'
        format.html { redirect_to(@configuration) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @configuration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /configurations/1
  # DELETE /configurations/1.xml
  def destroy
    @configuration = Configuration.find(params[:id])
    @configuration.destroy

    respond_to do |format|
      flash[:notice] = "Configuration was successfully destroyed"
      format.html { redirect_to(configurations_url) }
      format.xml  { head :ok }
    end
  end

  #refactor these
  def add_package
    @configuration = Configuration.find(params[:id])
    unless(params[:package_id])
      if(params[:query])
        @packages = Package.search(params[:query])
      end
      render :update do |page|
        page << "RedBox.showInline('hidden_content_alert')"
        page.replace_html "hidden_content_alert", :partial => "select_package_rb"
      end
    else
      @package = Package.find(params[:package_id])
      @configuration.packages << @package
      flash[:notice]="Package successfully added to end of configuration"
      render :update do |page|
        page.replace_html 'applied_packages', :partial => 'applied_packages'
        page.replace_html 'flash', :partial => 'shared/flashes'
        page << "RedBox.close()"
      end
    end
  end
  def remove_package
    @configuration = Configuration.find(params[:id])
    @applied_package = AppliedPackage.find(params[:applied_package_id])
    @applied_package.destroy
    render :update do |page|
      page.replace_html 'applied_packages', :partial => 'applied_packages'
    end
  end
  private
    def set_current_tab
      @current_tab = "configurations"
    end
end
