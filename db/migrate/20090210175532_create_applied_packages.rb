class CreateAppliedPackages < ActiveRecord::Migration
  def self.up
    create_table  :applied_packages do |t|
      t.integer   :package_id
      t.integer   :configuration_id
      t.timestamps
    end
  end

  def self.down
    drop_table :applied_packages
  end
end
