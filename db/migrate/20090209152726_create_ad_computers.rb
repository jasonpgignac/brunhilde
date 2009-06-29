class CreateAdComputers < ActiveRecord::Migration
  def self.up
    create_table  :ad_computers do |t|
      t.string    :remote_id
      t.integer  :content_server_id
      t.string    :name
      t.string    :user
      t.date      :last_cached
      t.date      :last_accessed 
      t.timestamps
    end
  end

  def self.down
    drop_table :ad_computers
  end
end
