class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :large_url
      t.string :thumb_url

      t.string :image_raw_file_name
      t.string :image_raw_content_type
      t.integer :image_raw_file_size
      t.timestamp :image_raw_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
