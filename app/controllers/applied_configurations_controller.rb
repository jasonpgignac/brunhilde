class AppliedConfigurationsController < ApplicationController
  def index
    @computer = Computer.find(params[:computer_id])
    @applied_configurations = @computer.applied_configurations

    respond_to do |format|
      format.xml  { render :xml   => @applied_configurations }
      format.json { render :json  => @applied_configurations }
    end
  end

  def new
    @computer = Computer.find(params[:computer_id])
    @applied_configuration = AppliedConfiguration.new
    if request.xhr?
      render :partial => "new_from_computer" if params[:search_for] == "configurations"
      render :partial => "new_hosted_from_computer" if params[:search_for] == "packages"
    end
  end
  def show
    @computer = Computer.find(params[:computer_id])
    @applied_configuration = AppliedConfiguration.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @applied_configuration.computer == @computer  
    respond_to do |format|
      format.xml  { render :xml => @applied_configuration }
      format.json { render :json => @applied_configuration }
    end
  end

  def create
    @computer = Computer.find(params[:computer_id])
    @applied_configuration = AppliedConfiguration.new(params[:applied_configuration])
    @applied_configuration.computer = @computer
    respond_to do |format|
      if @applied_configuration.save
        if request.xhr?
          format.js
        end
        format.xml  { render :xml => @applied_configuration, :status => :created }
        format.json { render :json => @applied_configuration, :status => :created }
      else
        puts "Errors: #{@applied_configuration.errors}"
        format.json { render :json => @applied_configuration.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @applied_configuration.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @computer = Computer.find(params[:computer_id])
    @applied_configuration = AppliedConfiguration.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @applied_configuration.computer == @computer  
    @applied_configuration.destroy

    respond_to do |format|
      if request.xhr?
        format.js
      end
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
end
