# This migration comes from mms_engine_engine (originally 20130311215857)
class ChangeFilenameInMetadataSources < ActiveRecord::Migration
  def up
    change_column :metadata_sources, :filename, :string, :null => false
  end

  def down
    change_column :metadata_sources, :filename, :string, :null => true
  end
end
