require 'csv'
class InstallValidationReaction < ActiveRecord::Base
  COMMAND_TYPES = ["wait","repeat","fatalerror","log","custom"]
  belongs_to    :install_validation
  acts_as_list  :scope => :install_validation
  validates_presence_of :command
  validates_inclusion_of :command, :in => COMMAND_TYPES
  validates_presence_of :parameter
  
  def self.csv_headers
    csv_string = String.new
    csv_string << ["command", "parameters", "repetitions"].to_csv
    return csv_string
  end
  def to_csv
    csv_string = String.new
    csv_string << ["ACTION", command, parameter, repetitions].to_csv
    return csv_string.sub!("\n", "")
  end
end
