require 'csv'
class PackageTestReaction < ActiveRecord::Base
  belongs_to    :package_test
  acts_as_list  :scope => :package_test
  
  def self.csv_headers
    csv_string= CSV.generate do |csv|
      csv << ["command", "parameters", "repetitions"]
    end
    return csv_string
  end
  def to_csv
    csv_string= CSV.generate do |csv|
      csv << ["ACTION", command, parameter, repetitions]
    end
    return csv_string.sub!("\n", "")
  end
end
