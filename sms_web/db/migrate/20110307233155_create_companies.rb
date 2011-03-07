class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :category

      t.string :contact
      t.string :address
      t.string :product

      t.text :desc

      t.string :site_url

      t.string :logo_url

      t.string :image_raw_file_name
      t.string :image_raw_content_type
      t.integer :image_raw_file_size
      t.timestamp :image_raw_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
