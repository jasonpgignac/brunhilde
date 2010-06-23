class Configuration < ActiveRecord::Base
  has_many  :applied_configurations,  :dependent => :destroy
  has_many  :applied_packages,        :order => :position,
                                      :dependent => :destroy
  has_many  :computers,               :through => :applied_configurations
  has_many  :packages,                :through =>:applied_packages,
                                      :order => :position
  belongs_to :host_computer,          :class_name => "Computer"
  belongs_to :owner,                  :class_name => "User"
  
  attr_accessor :applied_package_list
  
  validates_presence_of               :platform, 
                                      :name
  validates_uniqueness_of             :name
  validate                            :host_computer_is_only_related_computer_if_defined
  validates_inclusion_of              :platform, :in => PLATFORMS
  validate                            :applied_package_list_integrity_test
  validate                            :applied_packages_are_in_stage_order
  
  after_save :sort, :if => :applied_package_list 
                                              
  def self.search(query)
     if !query.to_s.strip.empty?
        tokens = query.split.collect {|c| "%#{c.downcase}%"}
        
        configurations = find_by_sql(["select c.* from configurations c where #{ (["(lower(c.name) like ?)"] * tokens.size).join(" and ") } order by c.name desc", *(tokens).sort])
        configurations.delete_if { |c| c.host_computer }
     else
        []
     end
  end
  def prescript_packages
    packages.clone.delete_if{ |p| p.deployment_stage != 0}
  end
  def postscript_packages
    packages.clone.delete_if{ |p| p.deployment_stage != 1}
  end
  
  private
  def host_computer_is_only_related_computer_if_defined
    if host_computer
      if computers.size == 0
        errors.add(:host_computer, "Configuration is hosted, but has no related computers")
      end
      if computers.size > 1
        errors.add(:host_computer, "Configuration is hosted, but is related to more than one computer")
      end
      if computers.size == 1 && computers[0] != host_computer
        errors.add(:host_computer, "Configuration is hosted, but is related to the wrong computer")
      end
    end 
  end
  def applied_package_list_integrity_test
    if @applied_package_list
      current_stage = 0
      @applied_package_list.each do |id|
        errors.add(:sorting, "Invalid object in sort list (#{id})") unless AppliedPackage.exists?(id) && AppliedPackage.find(id).configuration == self
        ap = AppliedPackage.find(id)
        errors.add(:sorting, "The sort request would put a stage #{ap.package.deployment_stage} object in stage #{current_stage}") if ap.package.deployment_stage < current_stage
        current_stage = ap.package.deployment_stage
      end
      applied_packages.each do |ap|
        errors.add(:sorting, "Object missing from the sort list (#{id})") unless @applied_package_list.include?(ap.id)
      end
    
    end
  end
  def applied_packages_are_in_stage_order
    current_stage = 0
    applied_packages.each { |ap|
      errors.add(:applied_packages, "There is a stage #{ap.package.deployment_stage} object in stage #{current_stage}") if ap.package.deployment_stage < current_stage
      current_stage = ap.package.deployment_stage
    }
  end
  def sort
    applied_package_list.each_with_index do | f, i |
      pkg = AppliedPackage.find(f)
      pkg.position = i
      pkg.save
    end
  end
end
