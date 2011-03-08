class Photo < ActiveRecord::Base

  belongs_to :racing_model
  belongs_to :car

  scope :cars, where("car_id is not null")
  scope :racing_models, where("racing_model_id is not null")
  scope :witout_car_and_racing_model, where("car_id is null and racing_model_id is null")


  # image_raw
  has_attached_file :image_raw,
    :styles => {
      :thumb => "128x128#"
    },
    :url  => "/_file/photos/:id_partition/raw/:style/:basename.:extension",
    :path => ":rails_root/public/_file/photos/:id_partition/raw/:style/:basename.:extension"


end
