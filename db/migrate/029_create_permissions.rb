class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 60, :null => false
      t.column :description, :text
    end
    add_index :permissions, :title, :unique => true
    role = AuthenticatedSystem::Role.find(1)
    p = AuthenticatedSystem::Permission.create :title => 'roles/index'
    role.permissions << p
    p = AuthenticatedSystem::Permission.create :title => 'roles/show'
    role.permissions << p
    p = AuthenticatedSystem::Permission.create :title => 'roles/edit'
    role.permissions << p
    p = AuthenticatedSystem::Permission.create :title => 'roles/update'
    role.permissions << p
    p = AuthenticatedSystem::Permission.create :title => 'main/admin'
    role.permissions << p
  end

  def self.down
    drop_table :permissions
  end
end
