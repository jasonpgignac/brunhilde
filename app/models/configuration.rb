class Configuration < ActiveRecord::Base
  has_many  :applied_configurations
  has_many  :applied_packages,        :order => :position
  has_many  :packages,                :through =>:applied_packages,
                                      :order => :position
                                      
  def self.search(query)
     if !query.to_s.strip.empty?
        tokens = query.split.collect {|c| "%#{c.downcase}%"}
        find_by_sql(["select c.* from configurations c where #{ (["(lower(c.name) like ?)"] * tokens.size).join(" and ") } order by c.name desc", *(tokens).sort])
     else
        []
     end
  end
  
end
