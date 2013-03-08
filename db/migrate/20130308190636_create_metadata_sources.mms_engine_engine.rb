# This migration comes from mms_engine_engine (originally 20130308190007)
class CreateMetadataSources < ActiveRecord::Migration
  def change
    create_table :metadata_sources, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :creator_id
      t.string :filename

      t.timestamps
    end
  end
end
