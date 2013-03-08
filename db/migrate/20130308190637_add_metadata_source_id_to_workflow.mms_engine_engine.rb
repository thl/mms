# This migration comes from mms_engine_engine (originally 20130308190455)
class AddMetadataSourceIdToWorkflow < ActiveRecord::Migration
  def change
    add_column :workflows, :metadata_source_id, :integer
  end
end
