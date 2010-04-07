class AppliedPackagesController < ApplicationController
  
  # DELETE /configurations/1
  # DELETE /configurations/1.xml
  def destroy
    @applied_package = AppliedPackage.find(params[:id])
    @configuration = @applied_package.configuration
    @applied_package.destroy

    respond_to do |format|
      format.html { redirect_to(@configuration) }
      format.xml  { head :ok }
    end
  end
  
end
