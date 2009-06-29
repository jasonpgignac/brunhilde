class AppliedConfiguration < ActiveRecord::Base
  belongs_to  :computer
  belongs_to  :configuration
  acts_as_list :scope => :computer
end
