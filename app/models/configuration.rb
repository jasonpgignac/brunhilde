class Configuration < ActiveRecord::Base
  has_many  :applied_configurations
  has_many  :applied_packages,        :order => :position
  has_many  :packages,                :through =>:applied_packages,
                                      :order => :position
end
