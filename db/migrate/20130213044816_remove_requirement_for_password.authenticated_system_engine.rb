# This migration comes from authenticated_system_engine (originally 20121017092455)
class RemoveRequirementForPassword < ActiveRecord::Migration
  def up
    change_column :users, :crypted_password, :string, :limit => 40, :null => true
  end

  def down
    change_column :users, :crypted_password, :string, :limit => 40, :null => false
  end
end