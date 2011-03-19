# == Schema Information
#
# Table name: cars
#
#  id                     :integer(4)      not null, primary key
#  company_id             :integer(4)
#  name                   :string(255)
#  price                  :string(255)
#  vehicle_type           :string(255)
#  engine_type            :string(255)
#  ventilation            :string(255)
#  fuel                   :string(255)
#  fuel_mileage           :string(255)
#  peak_output            :string(255)
#  seat_capacity          :string(255)
#  drive_type             :string(255)
#  transmission           :string(255)
#  voice_stream_url       :string(255)
#  video_stream_url       :string(255)
#  represented_at         :datetime
#  photo_large_url        :string(255)
#  photo_thumb_url        :string(255)
#  image_raw_file_name    :string(255)
#  image_raw_content_type :string(255)
#  image_raw_file_size    :integer(4)
#  image_raw_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  flickr_photo_id        :string(255)
#  flickr_photoset_id     :string(255)
#  desc                   :text
#

class Car < ActiveRecord::Base

  attr_accessor :represent_on

  validates_presence_of :company_id
  validates_presence_of :name, :price

  belongs_to :company
  has_many :photos
  has_many :car_photos, :class_name => "Photo"

  default_scope :order => "name ASC"


  # image_raw
  has_attached_file :image_raw,
    :styles => {
      :thumb => "128x128#"
    },
    :url  => "/_file/cars/:id_partition/raw/:style/:basename.:extension",
    :path => ":rails_root/public/_file/cars/:id_partition/raw/:style/:basename.:extension"




  def set_represent
    if self.represent_on.to_i == 1
      self.represented_at = Time.zone.now
    end
  end
  before_save :set_represent


  def upload_image_to_flickr
    photo_id = flickr.upload_photo self.image_raw.path, :title => self.name
    if photo_id
      self.update_attribute(:flickr_photo_id, photo_id)

      photo = flickr.photos.getInfo(:photo_id => self.flickr_photo_id)
      self.update_attributes(
        :photo_large_url => FlickRaw.url_short_m(photo),
        :photo_thumb_url => FlickRaw.url_short_s(photo)
      )
    end
  end


end
