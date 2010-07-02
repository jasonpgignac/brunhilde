class AppliedPackagesController < ApplicationController
  def index
    @configuration = Configuration.find(params[:configuration_id])
    @applied_packages = @configuration.applied_packages

    respond_to do |format|
      format.xml  { render :xml   => @applied_packages }
      format.json { render :json  => @applied_packages }
    end
  end
  
  def show
    @configuration = Configuration.find(params[:configuration_id])
    @applied_package = AppliedPackage.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @applied_package.configuration == @configuration  
    respond_to do |format|
      format.xml  { render :xml => @applied_package }
      format.json { render :json => @applied_package }
    end
  end
  
  def create
    @configuration = Configuration.find(params[:configuration_id])
    @applied_package = AppliedPackage.new(params[:applied_package])
    @applied_package.configuration = @configuration
    respond_to do |format|
      if @applied_package.save
        format.xml  { render :xml => @applied_package, :status => :created }
        format.json { render :json => @applied_package, :status => :created }
      else
        format.json { render :json => @applied_package.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @applied_package.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @configuration = Configuration.find(params[:configuration_id])
    @applied_package = AppliedPackage.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @applied_package.configuration == @configuration  
    @applied_package.destroy

    respond_to do |format|
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
  
end