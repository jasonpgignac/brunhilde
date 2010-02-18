class Configuration < ActiveRecord::Base
  has_many  :applied_configurations,  :dependent => :destroy
  has_many  :applied_packages,        :order => :position,
                                      :dependent => :destroy
  has_many  :packages,                :through =>:applied_packages,
                                      :order => :position
  belongs_to :host_computer,          :class_name => "Computer"
                                               
  def self.search(query)
     if !query.to_s.strip.empty?
        tokens = query.split.collect {|c| "%#{c.downcase}%"}
        find_by_sql(["select c.* from configurations c where #{ (["(lower(c.name) like ?)"] * tokens.size).join(" and ") } order by c.name desc", *(tokens).sort])
     else
        []
     end
  end
  
end
