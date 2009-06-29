class CreatePackageTestReactions < ActiveRecord::Migration
  def self.up
    create_table :package_test_reactions do |t|
      t.string      :command
      t.string      :parameter
      t.integer     :repetitions
      t.integer     :package_test_id
      t.integer     :position
      t.timestamps
    end
  end

  def self.down
    drop_table :package_test_reactions
  end
end
