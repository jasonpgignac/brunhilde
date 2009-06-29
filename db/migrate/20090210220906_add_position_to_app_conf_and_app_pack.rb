class AddPositionToAppConfAndAppPack < ActiveRecord::Migration
  def self.up
    add_column  :applied_packages,        :position,  :integer
    add_column  :applied_configurations,  :position,  :integer
  end

  def self.down
    drop_column :applied_packages,        :position
    drop_column :applied_configurations,  :position 
  end
end
