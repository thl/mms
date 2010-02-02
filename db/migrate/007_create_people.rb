class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :fullname, :string, :null => false
    end
    add_index :people, :fullname, :unique => true
  end

  def self.down
    drop_table :people
  end
end
