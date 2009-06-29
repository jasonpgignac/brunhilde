class Computer < ActiveRecord::Base
  has_many :applied_configurations, :order    => :position 
  has_many :configurations,         :through  => :applied_configurations,
                                    :order    => :position
  
  PRESCRIPT_PHASE = 0
  POSTSCRIPT_PHASE = 1
  
  def postscript
    postscript_prefix + script_body(POSTSCRIPT_PHASE) + postscript_suffix
  end
  def prescript
    prescript_prefix + script_body(PRESCRIPT_PHASE) + prescript_suffix
  end
  def packages
    package_list = Array.new
    configurations.each do |configuration|
      package_list = package_list + configuration.packages
    end
    return package_list
  end
  
  private
  
  def prescript_prefix
    prefix = [
                "REM *****************************************",
                "REM *                                       *",
                "REM *         Brunhilde Prescript          *",
                "REM *      Jason Gignac, Arturo Martinez    *",
                "REM *       NOTE: Dynamically Generated     *",
                "REM *                                       *",
                "REM *****************************************",
                "REM Generation Date: " + Time.now.strftime("%m/%d/%Y %I:%M:%S %p %Z"),
                "REM Target:          " + self.mac_address,
                "",
                ":prefix",
                "REM Load Environment Variables",
                "REM --Reads each line from var.txt, and executes it",
                "for /f \"tokens=* delims= \" %%a in (x:\\brunhilde\\var.txt) do (%%a)",
                "",
                "NET USE S: %BRUNHILDE_REPO_SRV% P@scpcs1nst /USER:PEROOT\\svc-eduhassatinst001",
                "SET BRUNHILDE_REPO_SRV=S:"
              ]
  end
  def prescript_suffix
    suffix = [
        ":suffix",
        "mkdir c:\\brunhilde",
        "copy /y x:\\brunhilde\\var.txt c:\\brunhilde",
        "copy /y x:\\brunhilde\\postscript.bat c:\\brunhilde",
        "Shutdown -r -t 5"
      ]
  end
  def postscript_prefix
    
    prefix = [
                  "REM *****************************************",
                  "REM *                                       *",
                  "REM *         Brunhilde Postscript          *",
                  "REM *      Jason Gignac, Arturo Martinez    *",
                  "REM *       NOTE: Dynamically Generated     *",
                  "REM *                                       *",
                  "REM *****************************************",
                  "REM Generation Date: " + Time.now.strftime("%m/%d/%Y %I:%M:%S %p %Z"),
                  "REM Target:          " + self.mac_address,
                  "",
                  ":prefix",
                  "REM Load Environment Variables",
                  "REM --Reads each line from var.txt, and executes it",
                  "for /f \"tokens=* delims= \" %%a in (c:\\brunhilde\\var.txt) do (%%a)",
                  "",
                  "REM Set up BRUNHILDEPHASE variable",
                  "if [%BRUNHILDEPHASE%]==[] (",
                  set_environment_variable("BRUNHILDEPHASE","0"),
                  "SET BRUNHILDEPHASE=0",
                  ")",
                  "",
                  "REM Wait until machine responds to ping before going on.",
                  ":pingwait",
                  "setLocal EnableDelayedExpansion",
                  "ping 10.133.16.35 | find \"Reply\" > nul",
                  "if errorlevel 1 (",
                  "echo Waiting...",
                  "goto :pingwait)",
                  "goto :phase%BRUNHILDEPHASE%",
                  "",
                  "NET USE S: %BRUNHILDE_REPO_SRV% P@scpcs1nst /USER:PEROOT\\svc-eduhassatinst001",
                  "SET BRUNHILDE_REPO_SRV=S:"]
  end
  def postscript_suffix
    suffix = [
                ":suffix",
                "cd \\",
                set_environment_variable("BRUNHILDEPHASE", nil),
                "REG delete \"HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\RunOnce\" /v BrunhildePost /f",
                "echo Script Completed",
                "reg delete \"HKLM\\software\\Microsoft\\windows nt\\currentversion\\winlogon\" /v DefaultPassword /f",
                "reg add \"HKLM\\software\\microsoft\\windows nt\\currentversion\\winlogon\" /v AutoadminLogon /t REG_SZ /d 0 /f",
                "reg add \"HKLM\\software\\microsoft\\windows nt\\currentversion\\winlogon\" /v DisableCAD /t REG_DWORD /d 0 /f",
                "del /f /q c:\\Brunhilde\\*.vbs",
                "rmdir /S /Q c:\\Cache",
                "Shutdown -r -t 5",
                "REM Script Complete"
                
                ]
  end
  def script_body(deployment_phase)
    script_for_packages = Array.new
    phase = 0
    self.packages.each do |package|
      execution=package.script(deployment_phase)
      if(execution.length > 0)
        script_for_packages << "REM Phase #{phase}: " + package.name
        script_for_packages << ":phase#{phase}"
        script_for_packages << set_environment_variable("BRUNHILDEPHASE",(phase + 1).to_s)
        script_for_packages = script_for_packages + execution
        script_for_packages << "echo Completed phase #{phase}"
        script_for_packages << ""
        phase = phase + 1
      end
    end
    return script_for_packages
  end
  def set_environment_variable(name, value)
    if value
      "REG ADD \"HKLM\\System\\CurrentControlSet\\Control\\Session Manager\\Environment\" /v #{name} /t REG_SZ /d \"#{value}\" /f"
    else
      "REG delete \"HKLM\\System\\CurrentControlSet\\Control\\Session Manager\\Environment\" /v #{name} /f"
    end
  end
  
end
