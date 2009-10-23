require 'csv'
class PackageTest < ActiveRecord::Base
  belongs_to    :package
  has_many      :package_test_reactions
  acts_as_list  :scope => :package
  
  def self.csv_headers
    csv_string = String.new
    csv_string << ["rule_type", "rule_parameter", "success_value"].to_csv
    return csv_string
  end
  def to_csv
    csv_string = String.new
    csv_string << ["TEST", rule_type, rule_parameter, success_value].to_csv
    return csv_string.sub!("\n", "")
  end
end 
