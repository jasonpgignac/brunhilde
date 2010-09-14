class ConfigurationsController < ApplicationController
  before_filter :set_current_tab
  
  # GET /configurations
  # GET /configurations.xml
  def index
    if params[:query]
      @configurations = Configuration.search(params[:query])
      @query = params[:query]
    else
      @configurations = Configuration.find_all_by_host_computer_id(nil)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @configurations }
      format.json { render :json => @configurations }
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
  
  def sort
    @configuration = Configuration.find(params[:id])
    @configuration.applied_packages.each do |applied_package|
      applied_package.position = params['item'].index(applied_package.id.to_s) + 1
      applied_package.save
    end
    render :nothing => true
  end
  
  private
    def set_current_tab
      @current_tab = "configurations"
    end
end
