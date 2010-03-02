class AddOwnerIdToPackage < ActiveRecord::Migration
  def self.up
	add_column :packages, :owner_id, :integer
	add_column :configurations, :owner_id, :integer
	add_column :computers, :owner_id, :integer
  end

  def self.down
	remove_column :package, :owner_id
	remove_column :configuration, :owner_id
	remove_column :computer, :ownder_id
  end
end
