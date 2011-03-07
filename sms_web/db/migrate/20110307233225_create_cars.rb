class CreateCars < ActiveRecord::Migration
  def self.up
    create_table :cars do |t|
      t.integer :company_id

      t.string :name
      t.string :price
      t.string :vehicle_type
      t.string :engine_type
      t.string :ventilation
      t.string :fuel
      t.string :fuel_mileage
      t.string :peak_output
      t.string :seat_capacity
      t.string :drive_type
      t.string :transmission

      t.string :voice_stream_url
      t.string :video_stream_url

      t.timestamp :represented_at

      t.string :photo_large_url
      t.string :phpto_thumb_url

      t.string :image_raw_file_name
      t.string :image_raw_content_type
      t.integer :image_raw_file_size
      t.timestamp :image_raw_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :cars
  end
end
