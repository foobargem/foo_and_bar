class RacingModel < ActiveRecord::Base

  validates_presence_of :name

  # image_raw
  has_attached_file :image_raw,
    :styles => {
      :thumb => "128x128#"
    },
    :url  => "/_file/cars/:id_partition/raw/:style/:basename.:extension",
    :path => ":rails_root/public/_file/cars/:id_partition/raw/:style/:basename.:extension"


end
