class User < ActiveRecord::Base
	acts_as_authentic
	has_many :roles
	has_many :packages, :foreign_key => :owner_id
	has_many :configurations, :foreign_key => :owner_id
	has_many :computers, :foreign_key => :owner_id
	
	def role_symbols 
	  (roles || []).map { |r| r.name.to_sym }
  end
end