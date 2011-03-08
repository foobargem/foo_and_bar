class RenamePhotoColumnToCars < ActiveRecord::Migration
  def self.up
    rename_column :cars, :phpto_thumb_url, :photo_thumb_url
  end

  def self.down
    rename_column :cars, :photo_thumb_url, :phhto_thumb_url
  end
end
