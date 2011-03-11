class RacingModel < ActiveRecord::Base

  validates_presence_of :name

  has_many :photos
  belongs_to :company

  has_many :racing_model_photos, :class_name => "Photo"

  # image_raw
  has_attached_file :image_raw,
    :styles => {
      :thumb => "128x128#"
    },
    :url  => "/_file/racing_models/:id_partition/raw/:style/:basename.:extension",
    :path => ":rails_root/public/_file/racing_models/:id_partition/raw/:style/:basename.:extension"


end
