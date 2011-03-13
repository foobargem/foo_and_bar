class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.string :title
      t.text :content
      t.string :landing_url

      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end
