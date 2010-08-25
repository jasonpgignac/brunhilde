class InstallValidationsController < ApplicationController
  before_filter :set_current_tab
  before_filter :atify_package
  def index
    @install_validations = @package.install_validations

    respond_to do |format|
      format.json { render :json => @install_validations}
      format.xml  { render :xml => @install_validations }
    end
  end

  # GET /install_validations/1
  # GET /install_validations/1.xml
  def show
    @install_validation = InstallValidation.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @install_validation.package == @package
    respond_to do |format|
      format.html { render :partial => "show_iv_row"}
      format.json  { render :json => @install_validation }
      format.xml  { render :xml => @install_validation }
    end
  end

  # GET /install_validations/new
  # GET /install_validations/new.xml
  def new
    @install_validation = InstallValidation.new

    respond_to do |format|
      if(request.xhr?)
        format.html { render :partial => "new_iv_row"}
      end
      format.json  { render :json => @install_validation }
      format.xml  { render :xml => @install_validation }
    end
  end
  
  def edit
    @install_validation = InstallValidation.find(params[:id])
    render :partial => "edit_iv_row"
  end
  
  def update
    @install_validation = InstallValidation.find(params[:id])
    respond_to do |format|
      if @install_validation.update_attributes(params[:install_validation])
        flash[:notice] = 'Validation was successfully updated.'
        format.html { render :partial => "show_iv_row" }
      else
        format.json { render :json => @install_validation.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @install_validation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # POST /install_validations
  # POST /install_validations.xml
  def create
    @install_validation = InstallValidation.new(params[:install_validation])
    @install_validation.package_id = @package.id
    respond_to do |format|
      if @install_validation.save
        if(request.xhr?)
          format.html { render :partial => "show_iv_row"}
        end
        format.json  { render :json => @install_validation, :status => :created, :location => package_install_validations_path(@package, @install_validation.id) }
        format.xml  { render :xml => @install_validation, :status => :created, :location => package_install_validations_path(@package, @install_validation.id) }
      else
        format.json { render :json => @install_validation.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @install_validation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /install_validations/1
  # DELETE /install_validations/1.xml
  def destroy
    @install_validation = InstallValidation.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @install_validation.package == @package
    @install_validation.destroy

    respond_to do |format|
      if request.xhr?
        format.js
      end
      format.json { head :ok}
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
