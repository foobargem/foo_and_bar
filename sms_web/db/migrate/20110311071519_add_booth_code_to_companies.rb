class AddBoothCodeToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :booth_code, :string
    add_column :companies, :flickr_photo_id, :string
    add_column :companies, :flickr_photoset_id, :string

    add_index :companies, :booth_code
  end

  def self.down
    remove_column :companies, :booth_code
    remove_column :companies, :flickr_photo_id
    remove_column :companies, :flickr_photoset_id

    remove_index :companies, :booth_code
  end
end
