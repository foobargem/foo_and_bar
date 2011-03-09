class Company < ActiveRecord::Base

  validates_presence_of :name

  has_many :cars
  #has_many :models


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
  end

  def logo_url
    self.image_raw.url
  end

end
