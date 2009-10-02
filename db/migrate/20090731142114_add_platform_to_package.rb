class AddPlatformToPackage < ActiveRecord::Migration
  def self.up
    add_column :packages, :platform, :string
  end

  def self.down
    remove_column :packages, :platform
  end
end
