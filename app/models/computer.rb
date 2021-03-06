class Computer < ActiveRecord::Base
  has_many :applied_configurations, :order        => :position,
                                    :dependent    => :destroy
  has_many :configurations,         :through      => :applied_configurations,
                                    :order        => :position
  has_many :hosted_configurations,  :class_name   => "Configuration",
                                    :foreign_key  => :host_computer_id,
                                    :dependent    => :destroy
  belongs_to :owner, :class_name => "User"
  attr_accessor :applied_configuration_list
  
  validates_presence_of :mac_address, :platform
  validates_uniqueness_of :mac_address
  validates_associated :applied_configurations
  validates_inclusion_of :platform, :in => PLATFORMS
  validate :applied_configuration_list_integrity_test
  after_save :sort, :if => :applied_configuration_list
  
  PRESCRIPT_PHASE = 0
  POSTSCRIPT_PHASE = 1
  
  def self.search(query)
     if !query.to_s.strip.empty?
        tokens = query.split.collect {|c| "%#{c.downcase}%"}
        computers = find_by_sql(["select c.* from computers c where #{ (["(lower(c.name) like ?)"] * tokens.size).join(" and ") } order by c.name desc", *(tokens).sort])
     else
        []
     end
  end
  def postscript
    if (self.platform == "PC")
      pc_postscript_prefix + pc_script_body(POSTSCRIPT_PHASE) + pc_postscript_suffix
    elsif (self.platform == "Mac")
      mac_postscript_prefix + mac_script_body(POSTSCRIPT_PHASE) + mac_postscript_suffix
    end
  end
  def prescript
    if (self.platform == "PC")
      pc_prescript_prefix + pc_script_body(PRESCRIPT_PHASE) + pc_prescript_suffix
    elsif (self.platform == "Mac")
      mac_header + mac_script_body(PRESCRIPT_PHASE) + mac_prescript_suffix
    end
  end
  def packages
    package_list = Array.new
    configurations.each do |configuration|
      package_list = package_list + configuration.packages
    end
    return package_list
  end
  
  private
  
  def pc_prescript_prefix
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
                "CALL var.bat",
                "",
                "NET USE S: %BRUNHILDE_REPO_SRV% P@scpcs1nst /USER:PEROOT\\svc-eduhassatinst001",
                "SET BRUNHILDE_REPO_SRV=S:"
              ]
  end
  def pc_prescript_suffix
    suffix = [
        ":suffix",
        "mkdir c:\\brunhilde",
        "copy /y x:\\brunhilde\\var.txt c:\\brunhilde",
	"copy /y x:\\brunhilde\\var.bat c:\\brunhilde",
        "copy /y x:\\brunhilde\\postscript.bat c:\\brunhilde",
        "Shutdown -r -t 5"
      ]
  end
  def pc_postscript_prefix
    
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
                  "CALL c:\\brunhilde\\var.bat",
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
                  "ping 10.133.16.35 | find \"Reply\" > nul",
                  "ping 10.133.16.35 | find \"Reply\" > nul",
                  "if errorlevel 1 (",
                  "echo Waiting...",
                  "goto :pingwait)",
                  "NET USE S: %BRUNHILDE_REPO_SRV% P@scpcs1nst /USER:PEROOT\\svc-eduhassatinst001",
                  "if errorlevel 1 (",
                  "echo Netowrk Not found",
                  "goto :pingwait)",
                  "SET BRUNHILDE_REPO_SRV=S:",
                  "goto :phase%BRUNHILDEPHASE%"]
  end
  def pc_postscript_suffix
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
  def pc_script_body(deployment_phase)
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
  
  def mac_header
    header = [
                "#!/bin/bash",
                "# *****************************************",
                "# *                                       *",
                "# *         Brunhilde Prescript          *",
                "# *      Jason Gignac, Arturo Martinez    *",
                "# *       NOTE: Dynamically Generated     *",
                "# *                                       *",
                "# *****************************************",
                "# Generation Date: " + Time.now.strftime("%m/%d/%Y %I:%M:%S %p %Z"),
                "# Target:          " + self.mac_address,
                "if ! test $BRUNHILDEPHASE",
                "then",
                "BRUNHILDEPHASE=1",
                "fi",
                ""
    ]
  end
  def mac_prefix
    prefix = [
                "# PREFIX",
                "# Load Environment Variable from mac_var.txt",
                "# (Execute mac_var.txt)",
                "source /brunhilde/mac_var.txt",
                "echo REPO: $BRUNHILDE_REPO_SRV",
                "echo IMAGE: $BRUNHILDE_IMAGE_SRV",
                "# Wait until machine responds to ping before going on.",
                "while ping -c 1 -w 15 google.com &> /dev/null",
                "do",
                "echo Waiting for ping to succeed...",
                "done",
                "# Mount the Software Repository",
                "mkdir /brunhilde/softwarerepository",
                "mount_afp afp://PEROOT\\\\svc-eduhassatinst001:P%40scpcs1nst@$BRUNHILDE_REPO_SRV /brunhilde/softwarerepository",
                "BRUNHILDE_REPO_SRV=/brunhilde/softwarerepository",
                "",
                "# Set up BRUNHILDEPHASE variable",
                
              ]
  end
  def mac_prescript_suffix
    suffix = [
        "# SUFFIX",
        "mkdir /Volumes/InstaDMG/brunhilde",
        "cp /brunhilde/mac_var.txt /Volumes/InstaDMG/brunhilde/",
        "cp /brunhilde/postscript.bash /Volumes/InstaDMG/brunhilde/",
        "# shutdown -r now"
      ]
  end
  def mac_postscript_suffix
  end
  def mac_script_body(deployment_phase)
    script_for_packages = Array.new
    phase = 0
    if (deployment_phase = PRESCRIPT_PHASE) then
      script_for_packages = script_for_packages + add_mac_function("Prefix", mac_prefix, phase)
    end
    self.packages.each do |package|
      execution=package.script(deployment_phase)
      if(execution.length > 0)
        phase = phase + 1
        script_for_packages = script_for_packages + add_mac_function( package.name,
                                                                      execution, 
                                                                      phase)
      end
    end
    script_for_packages << "phase0"
    puts "Phase : #{phase}"
    if (phase > 0) then
      script_for_packages << "for ((i=$BRUNHILDEPHASE;i<=#{phase};i++))";
      script_for_packages << "do"
      script_for_packages << "phase$i"
      script_for_packages << "done"
    end
    return script_for_packages
  end
  def add_mac_function(title, script_to_insert, phase)
    function = Array.new
     function << "# Phase #{phase}: " + title.to_s
      function << "function phase#{phase} {"
      function << ""
      function << "echo BRUNHILDEPHASE=#{phase + 1} >> /brunhilde/mac_var.txt"
      function = function + script_to_insert
      function << "echo Completed phase #{phase}"
      function << "}"
      function << ""
  end

  private
  def applied_configuration_list_integrity_test
    if @applied_configuration_list
      ac_list_as_i = @applied_configuration_list.map{ |x| x.to_i }
      ac_list_as_i.each do |id|
        errors.add(:sorting, "Invalid object in sort list (#{id})") unless AppliedConfiguration.exists?(id.to_i) && AppliedConfiguration.find(id.to_i).computer == self
      end
      applied_configurations.each do |ac|
        errors.add(:sorting, "Object missing from the sort list (#{id})") unless ac_list_as_i.include?(ac.id.to_i)
      end
    end
  end
  def sort
    applied_configuration_list.each_with_index do | f,i |
      ac = applied_configurations.find(f.to_i)
      ac.position = i
      ac.save
    end
    applied_configuration_list = nil
  end
end
