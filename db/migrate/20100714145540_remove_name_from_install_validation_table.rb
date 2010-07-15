class RemoveNameFromInstallValidationTable < ActiveRecord::Migration
  def self.up
	remove_column :install_validations, :name
  end

  def self.down
	add_column :install_validations, :name, :string
  end
end
