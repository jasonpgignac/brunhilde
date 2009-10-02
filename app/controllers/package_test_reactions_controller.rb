class PackageTestReactionsController < ApplicationController
  before_filter :atify_package_and_test
  # GET /package_test_reactions
  # GET /package_test_reactions.xml
  def index
    @packages = PackageTestReaction.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @package_test_reactions }
    end
  end

  # GET /package_test_reactions/1
  # GET /package_test_reactions/1.xml
  def show
    @package = PackageTestReaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package_test_reaction }
    end
  end

  # GET /package_test_reactions/new
  # GET /package_test_reactions/new.xml
  def new
    @package_test_reaction = PackageTestReaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @package_test_reaction }
    end
  end

  # GET /package_test_reactions/1/edit
  def edit
    @package_test_reaction = PackageTestReaction.find(params[:id])
  end

  # POST /package_test_reactions
  # POST /package_test_reactions.xml
  def create
    @package_test_reaction = PackageTestReaction.new(params[:package_test_reaction])
    @package_test_reaction.package_test = @package_test
    respond_to do |format|
      if @package_test_reaction.save
        flash[:notice] = 'PackageTestReaction was successfully created.'
        format.html { redirect_to(package_test_path(@package, @package_test)) }
        format.xml  { render :xml => @package_test_reaction, :status => :created, :location => package_test_reaction_path(@package, @package_test, @package_test_reaction) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package_test_reaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /package_test_reactions/1
  # PUT /package_test_reactions/1.xml
  def update
    @package_test_reaction = PackageTestReaction.find(params[:id])

    respond_to do |format|
      if @package_test_reaction.update_attributes(params[:package_test_reaction])
        flash[:notice] = 'PackageTestReaction was successfully updated.'
        format.html { redirect_to(package_test_path(@package, @package_test)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package_test_reaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /package_test_reactions/1
  # DELETE /package_test_reactions/1.xml
  def destroy
    @package_test_reaction = PackageTestReaction.find(params[:id])
    @package_test_reaction.destroy

    respond_to do |format|
      format.html { redirect_to(package_test_path(@package, @package_test)) }
      format.xml  { head :ok }
    end
  end
  
  private
  def atify_package_and_test
    @package = Package.find(params[:package_id])
    @package_test = @package.package_tests.find(params[:test_id])
  end
end
