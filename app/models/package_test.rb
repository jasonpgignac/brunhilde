require 'csv'
class PackageTest < ActiveRecord::Base
  belongs_to    :package
  has_many      :package_test_reactions
  acts_as_list  :scope => :package
  
  def self.csv_headers
    csv_string= CSV.generate do |csv|
      csv << ["rule_type", "rule_parameter", "success_value"]
    end
    return csv_string
  end
  def to_csv
    csv_string= CSV.generate do |csv|
      sval = success_value ? 1 : 0
      csv << ["TEST", rule_type, rule_parameter, sval]
    end
    return csv_string.sub!("\n", "")
  end
end 
