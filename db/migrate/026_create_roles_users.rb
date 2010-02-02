class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
      t.column :role_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
    add_index :roles_users, [:role_id, :user_id], :unique => true
  end

  def self.down
    drop_table :roles_users
  end
end
