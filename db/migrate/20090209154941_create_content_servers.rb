class CreateContentServers < ActiveRecord::Migration
  def self.up
    create_table :content_servers do |t|
      t.string      :name;
      t.string      :address;
      t.string      :username;
      t.string      :password;
      t.string      :server_type;
      t.timestamps
    end
  end

  def self.down
    drop_table :content_servers
  end
end
