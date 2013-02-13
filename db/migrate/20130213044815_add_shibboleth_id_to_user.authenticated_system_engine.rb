# This migration comes from authenticated_system_engine (originally 20121011173743)
class AddShibbolethIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :shibboleth_id, :string
  end
end
