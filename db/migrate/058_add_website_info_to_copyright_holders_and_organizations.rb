class AddWebsiteInfoToCopyrightHoldersAndOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :website, :string
    add_column :copyright_holders, :website, :string
  end

  def self.down
    remove_column :organizations, :website
    remove_column :copyright_holders, :website
  end
end
