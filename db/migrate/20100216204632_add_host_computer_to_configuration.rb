class AddHostComputerToConfiguration < ActiveRecord::Migration
  def self.up
    add_column :configurations, :host_computer_id, :integer
  end

  def self.down
    remove_column :configurations, :host_computer_id
  end
end
