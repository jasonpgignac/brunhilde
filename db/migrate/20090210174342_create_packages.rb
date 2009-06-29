class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table  :packages do |t|
      t.string    :name
      t.boolean   :licensed
      t.boolean   :prescript
      t.string    :source_path
      t.string    :executable
      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end
