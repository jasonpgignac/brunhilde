class AddPlatformFieldToComputers < ActiveRecord::Migration
  def self.up
    add_column :computers, :platform, :string
  end

  def self.down
    remove_column :computers, :platform, :string
  end
end
