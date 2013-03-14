# This migration comes from mms_engine_engine (originally 20130313221408)
class AddOriginalPathToWorkflow < ActiveRecord::Migration
  def change
    add_column :workflows, :original_path, :text
  end
end
