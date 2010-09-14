require 'csv'
class InstallValidation < ActiveRecord::Base
  belongs_to    :package
  has_many      :install_validation_reactions
  acts_as_list  :scope => :package
  validates_presence_of   :package, :success_value, :rule_type, :rule_parameter
  validates_inclusion_of :rule_type, :in => RULE_TYPES
  accepts_nested_attributes_for :install_validation_reactions, :allow_destroy => true
  
  def self.rule_types
    return RULE_TYPES
  end
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
