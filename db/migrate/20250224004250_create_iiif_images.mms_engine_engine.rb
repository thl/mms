# This migration comes from mms_engine_engine (originally 20250224003832)
class CreateIiifImages < ActiveRecord::Migration
  def change
    create_table :iiif_images do |t|
      t.references :picture, index: true, null: false
      t.text :shanti_url, null: false
      t.string :api_url, null: false
      t.string :uid, null: false

      t.timestamps
    end
  end
end
