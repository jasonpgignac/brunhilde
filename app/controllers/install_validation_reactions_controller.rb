class InstallValidationReactionsController < ApplicationController
  before_filter :set_current_tab
  before_filter :atify_package_and_test
  # GET /install_validation_reactions
  # GET /install_validation_reactions.xml
  def index
    @install_validation_reactions = @install_validation.install_validation_reactions

    respond_to do |format|
      format.json { render :json => @install_validation_reactions }
      format.xml  { render :xml => @install_validation_reactions }
    end
  end

  # GET /install_validation_reactions/1
  # GET /install_validation_reactions/1.xml
  def show
    @install_validation_reaction = InstallValidationReaction.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @install_validation_reaction.install_validation == @install_validation
    raise ActiveRecord::RecordNotFound unless @install_validation_reaction.install_validation.package == @package
    respond_to do |format|
      format.json { render :json => @install_validation_reaction }
      format.xml  { render :xml => @install_validation_reaction }
    end
  end

  # POST /install_validation_reactions
  # POST /install_validation_reactions.xml
  def create
    @install_validation_reaction = InstallValidationReaction.new(params[:install_validation_reaction])
    @install_validation_reaction.install_validation = @install_validation
    respond_to do |format|
      if @install_validation_reaction.save
        format.json { render :json => @install_validation_reaction, :status => :created, :location => package_install_validation_install_validation_reaction_path(@package, @install_validation, @install_validation_reaction) }
        format.xml  { render :xml => @install_validation_reaction, :status => :created, :location => package_install_validation_install_validation_reaction_path(@package, @install_validation, @install_validation_reaction) }
      else
        format.json  { render :json => @install_validation_reaction.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @install_validation_reaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /install_validation_reactions/1
  # PUT /install_validation_reactions/1.xml
  def update
    @install_validation_reaction = InstallValidationReaction.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @install_validation_reaction.install_validation == @install_validation
    raise ActiveRecord::RecordNotFound unless @install_validation_reaction.install_validation.package == @package
    
    respond_to do |format|
      if @install_validation_reaction.update_attributes(params[:install_validation_reaction])
        format.json { head :ok }
        format.xml  { head :ok }
      else
        format.json  { render :json => @install_validation_reaction.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @install_validation_reaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /install_validation_reactions/1
  # DELETE /install_validation_reactions/1.xml
  def destroy
    @install_validation_reaction = InstallValidationReaction.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @install_validation_reaction.install_validation == @install_validation
    raise ActiveRecord::RecordNotFound unless @install_validation_reaction.install_validation.package == @package
    @install_validation_reaction.destroy

    respond_to do |format|
      format.json { head :ok }
      format.xml  { head :ok }
    end
  end
  
  private
  def set_current_tab
    @current_tab = "packages"
  end
  def atify_package_and_test
    @package = Package.find(params[:package_id])
    @install_validation = @package.install_validations.find(params[:install_validation_id])
  end
end
