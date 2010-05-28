require 'csv'
class Package < ActiveRecord::Base
  has_many  :applied_packages,  :dependent => :destroy
  has_many  :package_tests
  belongs_to :owner, :class_name => "User"
  
  def self.search(query)
     if !query.to_s.strip.empty?
        tokens = query.split.collect {|c| "%#{c.downcase}%"}
        find_by_sql(["select p.* from packages p where #{ (["(lower(p.name) like ?)"] * tokens.size).join(" and ") } order by p.name desc", *(tokens).sort])
     else
        []
     end
  end
  
  def driveletter
    if(self.deployment_stage==0)
      return "x"
    else
      return "c"
    end
  end
  def script(stage)
    if self.deployment_stage==stage
      return copy_script + install_script + test_install_script
    else
      return Array.new
    end
  end
  def copy_script
    new_script = Array.new
    unless platform=="MAC"
      new_script << "md \\cache"
      new_script << "md \"" + self.driveletter + ":\\cache\\" + self.source_path + "\""
      new_script << "xcopy \"%BRUNHILDE_REPO_SRV%\\" + self.source_path + "\" \"" + self.driveletter + ":\\cache\\" + self.source_path + "\" /Y /R /H /I /E /Q"
    else
      new_script << "mkdir -p /cache"
      new_script << "mkdir -p \"/cache/" + self.source_path + "\""
      new_script << "cp -f -R  \"$BRUNHILDE_REPO_SRV/" + self.source_path + "\" \"/cache/" + self.source_path + "\""
    end
    return new_script
  end
  def install_script
    new_script = Array.new
    unless platform=="MAC"
      new_script << "cd /d \"" + self.driveletter + ":\\cache\\" + self.source_path + "\\\""
      new_script << "call " + self.executable
    else
      new_script << "cd \"/cache/" + self.source_path + "\""
      new_script << "pwd"
      new_script << "source \"./" + self.executable + "\""
    end
    return new_script
  end
  def test_install_script
    new_script = Array.new
    package_tests.each do |test|
      new_script << "REM Test Name: " + test.name
      new_script << "REM Test Description: " + test.description
      new_script << "echo " + test.to_csv + " >> c:\\brunhilde\\pending_tests.txt"
      test.package_test_reactions.each do |action|
        new_script << "echo " + action.to_csv + " >> c:\\brunhilde\\pending_tests.txt"
      end
    end
    return new_script
  end
end
