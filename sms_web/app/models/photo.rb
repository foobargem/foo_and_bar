class Photo < ActiveRecord::Base

  # image_raw
  has_attached_file :image_raw,
    :styles => {
      :thumb => "128x128#"
    },
    :url  => "/_file/photos/:id_partition/raw/:style/:basename.:extension",
    :path => ":rails_root/public/_file/photos/:id_partition/raw/:style/:basename.:extension"


end
