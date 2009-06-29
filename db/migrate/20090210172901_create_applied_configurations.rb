class CreateAppliedConfigurations < ActiveRecord::Migration
  def self.up
    create_table  :applied_configurations do |t|
      t.integer   :configuration_id
      t.integer   :computer_id
      t.timestamps
    end
  end

  def self.down
    drop_table :applied_configurations
  end
end
