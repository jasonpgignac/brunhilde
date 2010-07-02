class ImagingAccessController < ApplicationController
 
  def prescript
    @macaddress = params[:id]  
    computer = Computer.find_last_by_mac_address(@macaddress)
    if computer
      @prescript = computer.prescript
    else
      @prescript = Array.new()
    end
  end
  
  def postscript
    @macaddress = params[:id]  
    computer = Computer.find_last_by_mac_address(@macaddress)
    if computer
      @postscript = computer.postscript
    else
      @postscript = Array.new()
    end
  end
  
end
