# == Schema Information
#
# Table name: companies
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(255)
#  category               :string(255)
#  contact                :string(255)
#  address                :string(255)
#  product                :string(255)
#  desc                   :text
#  site_url               :string(255)
#  logo_url               :string(255)
#  image_raw_file_name    :string(255)
#  image_raw_content_type :string(255)
#  image_raw_file_size    :integer(4)
#  image_raw_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  booth_code             :string(255)
#  flickr_photo_id        :string(255)
#  flickr_photoset_id     :string(255)
#

class Company < ActiveRecord::Base

  validates_presence_of :name

  has_many :cars
  has_many :racing_models

  has_many :car_photos, :class_name => "Photo", :through => :cars
  has_many :racing_model_photos, :class_name => "Photo", :through => :racing_models


  scope :car_part, where("category = ?", "car")
  scope :component_part, where("category = ?", "component")
  scope :goods_part, where("category = ?", "goods")


  # image_raw
  has_attached_file :image_raw,
    :styles => {
      :thumb => "128x128#"
    },
    :url  => "/_file/companies/:id_partition/raw/:style/:basename.:extension",
    :path => ":rails_root/public/_file/companies/:id_partition/raw/:style/:basename.:extension"


  def upload_image_to_flickr
    photo_id = flickr.upload_photo self.image_raw.path, :title => self.name
    if photo_id
      self.update_attribute(:flickr_photo_id, photo_id)

      photo = flickr.photos.getInfo(:photo_id => self.flickr_photo_id)
      self.update_attribute(:logo_url, FlickRaw.url_short_m(photo))
    end
  end

end
