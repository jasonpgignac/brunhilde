class AddPlatformToConfigurations < ActiveRecord::Migration
  def self.up
    add_column :configurations, :platform, :string
  end

  def self.down
    remove_column :configurations, :platform
  end
end
