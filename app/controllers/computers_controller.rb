class ComputersController < ApplicationController
  before_filter :set_current_tab
  # GET /computers
  # GET /computers.xml
  def index
    @computers = Computer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @computers }
    end
  end

  # GET /computers/1
  # GET /computers/1.xml
  def show
    @computer = Computer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @computer }
    end
  end

  # GET /computers/new
  # GET /computers/new.xml
  def new
    @computer = Computer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @computer }
    end
  end

  # GET /computers/1/edit
  def edit
    @computer = Computer.find(params[:id])
  end

  # POST /computers
  # POST /computers.xml
  def create
    @computer = Computer.new(params[:computer])
    @computer.owner = current_user
    respond_to do |format|
      if @computer.save
        flash[:notice] = 'Computer was successfully created.'
        format.html { redirect_to(@computer) }
        format.xml  { render :xml => @computer, :status => :created, :location => @computer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @computer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /computers/1
  # PUT /computers/1.xml
  def update
    @computer = Computer.find(params[:id])

    respond_to do |format|
      if @computer.update_attributes(params[:computer])
        flash[:notice] = 'Computer was successfully updated.'
        format.html { redirect_to(@computer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @computer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /computers/1
  # DELETE /computers/1.xml
  def destroy
    @computer = Computer.find(params[:id])
    @computer.destroy

    respond_to do |format|
      format.html { redirect_to(computers_url) }
      format.xml  { head :ok }
    end
  end
  
  def sort
    @computer = Computer.find(params[:id])
    buildset = params["applied-configuration-list"].each_with_index do | f,i |
      c = AppliedConfiguration.find(f)
      c.position = i
      c.save
    end
    
    render :update do |page|
      page.replace_html 'applied_configurations', :partial => 'applied_configurations'
    end
  end
  def add_configuration
    @computer = Computer.find(params[:id])
    unless(params[:configuration_id])
      if(params[:query])
        @configurations = Configuration.search(params[:query])
      end
      render :update do |page|
        page << "RedBox.showInline('hidden_content_alert')"
        page.replace_html "hidden_content_alert", :partial => "select_configuration"
      end
    else
      @configuration = Configuration.find(params[:configuration_id])
      @computer.configurations << @configuration
      flash[:notice]="Configuration successfully added to end of computer"
      render :update do |page|
        page.replace_html 'applied_configurations', :partial => 'applied_configurations'
        page.replace_html 'flash', :partial => 'shared/flashes'
        page << "RedBox.close()"
      end
    end
  end
  def add_package
    @computer = Computer.find(params[:id])
    unless(params[:package_id])
      if(params[:query])
        @packages = Package.search(params[:query])
      end
      render :update do |page|
        page << "RedBox.showInline('hidden_content_alert')"
        page.replace_html "hidden_content_alert", :partial => "select_package"
      end
    else
      @package = Package.find(params[:package_id])
      configuration = Configuration.new(:name => "Package (#{@package.name})")
      @computer.hosted_configurations << configuration
      @computer.configurations << configuration
      configuration.save
      configuration.packages << @package
      @package.save
      flash[:notice]="Package successfully added to end of computer"
      render :update do |page|
        page.replace_html 'applied_configurations', :partial => 'applied_configurations'
        page.replace_html 'flash', :partial => 'shared/flashes'
        page << "RedBox.close()"
      end
    end
  end
  def remove_configuration
    @computer = Computer.find(params[:id])
    @applied_configuration = AppliedConfiguration.find(params[:applied_configuration_id])
    if @applied_configuration.configuration.host_computer == @computer
      @applied_configuration.configuration.destroy
    else
      @applied_configuration.destroy
    end
    render :update do |page|
      page.replace_html 'applied_configurations', :partial => 'applied_configurations'
    end
  end
  private
    def set_current_tab
      @current_tab = "computers"
    end
end
