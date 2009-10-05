class PackageTestReaction < ActiveRecord::Base
  belongs_to    :package_test
  acts_as_list  :scope => :package_test
  
  def self.csv_headers
    csv_string << ["command", "parameters", "repetitions"].to_csv
    return csv_string
  end
  def to_csv
    csv_string << ["ACTION", command, parameter, repetitions].to_csv
    return csv_string.sub!("\n", "")
  end
end
