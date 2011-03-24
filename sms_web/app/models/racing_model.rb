# == Schema Information
#
# Table name: racing_models
#
#  id                     :integer(4)      not null, primary key
#  company_id             :integer(4)
#  name                   :string(255)
#  birth                  :string(255)
#  blood_type             :string(255)
#  height                 :string(255)
#  weight                 :string(255)
#  dress_size             :string(255)
#  bwh                    :string(255)
#  shoe_size              :string(255)
#  hobby                  :string(255)
#  homepage_url           :string(255)
#  fan_site_url           :string(255)
#  career_desc            :text
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
#

class RacingModel < ActiveRecord::Base

  validates_presence_of :name

  has_many :photos
  belongs_to :company
  has_many :racing_model_photos, :class_name => "Photo"

  default_scope :order => "id DESC"

  scope :published, where("published = ?", true)
  scope :unpublished, where("published = ?", false)

  scope :included_company, where("company_id is not null")


  # image_raw
  has_attached_file :image_raw,
    :styles => {
      :thumb => "128x128#"
    },
    :url  => "/_file/racing_models/:id_partition/raw/:style/:basename.:extension",
    :path => ":rails_root/public/_file/racing_models/:id_partition/raw/:style/:basename.:extension"


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


  def career_desc_to_html
    unless self.career_desc.nil?
      self.career_desc.gsub("\r\n", "<br />")
    end
  end

end
