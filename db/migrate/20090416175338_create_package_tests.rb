class CreatePackageTests < ActiveRecord::Migration
  def self.up
    create_table :package_tests do |t|
      t.integer     :package_id
      t.string      :name
      t.string      :description
      t.string      :rule_type
      t.string      :rule_parameter
      t.string      :success_value
      t.string      :position
      t.timestamps
    end
  end

  def self.down
    drop_table :package_tests
  end
end
