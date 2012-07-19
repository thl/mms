class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 20, :null => false
      t.column :description, :text
    end
    add_index :roles, :title, :unique => true
    role = AuthenticatedSystem::Role.create :title => 'System Administrator'
    user = AuthenticatedSystem::User.find(1)
    role.users << user
  end

  def self.down
    drop_table :roles
  end
end
