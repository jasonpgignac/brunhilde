class AppliedConfigurationsController < ApplicationController
  def index
    @computer = Computer.find(params[:computer_id])
    @applied_configurations = @computer.applied_configurations

    respond_to do |format|
      format.xml  { render :xml   => @applied_configurations }
      format.json { render :json  => @applied_configurations }
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
        format.xml  { render :xml => @applied_configuration, :status => :created }
        format.json { render :json => @applied_configuration, :status => :created }
      else
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
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end
end
