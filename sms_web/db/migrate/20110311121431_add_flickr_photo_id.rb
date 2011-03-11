class AddFlickrPhotoId < ActiveRecord::Migration
  def self.up
    add_column :cars, :flickr_photo_id, :string
    add_column :cars, :flickr_photoset_id, :string

    add_column :photos, :flickr_photo_id, :string
    add_column :photos, :flickr_photoset_id, :string

    add_column :racing_models, :flickr_photo_id, :string
    add_column :racing_models, :flickr_photoset_id, :string
  end

  def self.down
    remove_column :cars, :flickr_photo_id
    remove_column :cars, :flickr_photoset_id

    remove_column :photos, :flickr_photo_id
    remove_column :photos, :flickr_photoset_id

    remove_column :racing_models, :flickr_photo_id
    remove_column :racing_models, :flickr_photoset_id
  end
end
