# == Schema Information
#
# Table name: photos
#
#  id                     :integer(4)      not null, primary key
#  large_url              :string(255)
#  thumb_url              :string(255)
#  image_raw_file_name    :string(255)
#  image_raw_content_type :string(255)
#  image_raw_file_size    :integer(4)
#  image_raw_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  company_id             :integer(4)
#  car_id                 :integer(4)
#  racing_model_id        :integer(4)
#  flickr_photo_id        :string(255)
#  flickr_photoset_id     :string(255)
#

class Photo < ActiveRecord::Base

  belongs_to :racing_model
  belongs_to :car

  scope :cars, where("car_id is not null")
  scope :racing_models, where("racing_model_id is not null")
  scope :without_car_and_racing_model, where("car_id is null and racing_model_id is null")
  scope :with_car_and_racing_model, where("car_id is not null and racing_model_id is not null")


  # image_raw
  has_attached_file :image_raw,
    :styles => {
      :thumb => "128x128#"
    },
    :url  => "/_file/photos/:id_partition/raw/:style/:basename.:extension",
    :path => ":rails_root/public/_file/photos/:id_partition/raw/:style/:basename.:extension"

end
