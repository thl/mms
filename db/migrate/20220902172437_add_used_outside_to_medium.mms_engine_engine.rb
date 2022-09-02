# This migration comes from mms_engine_engine (originally 20220902171954)
class AddUsedOutsideToMedium < ActiveRecord::Migration
  def change
    add_column :media, :used_outside, :boolean, null: false, default: false
  end
end
