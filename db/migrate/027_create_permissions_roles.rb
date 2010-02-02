class CreatePermissionsRoles < ActiveRecord::Migration
  def self.up
    create_table :permissions_roles, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
      t.column :permission_id, :integer, :null => false
      t.column :role_id, :integer, :null => false
    end
    add_index :permissions_roles, [:permission_id, :role_id], :unique => true
  end

  def self.down
    drop_table :permissions_roles
  end
end
