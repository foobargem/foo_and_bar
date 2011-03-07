class CreateRacingModels < ActiveRecord::Migration
  def self.up
    create_table :racing_models do |t|
      t.integer :company_id

      t.string :name
      t.string :birth
      t.string :blood_type
      t.string :height
      t.string :weight
      t.string :dress_size
      t.string :bwh
      t.string :shoe_size
      t.string :hobby
      t.string :homepage_url
      t.string :fan_site_url
      t.text :career_desc

      t.string :photo_large_url
      t.string :photo_thumb_url

      t.string :image_raw_file_name
      t.string :image_raw_content_type
      t.integer :image_raw_file_size
      t.timestamp :image_raw_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :racing_models
  end
end
