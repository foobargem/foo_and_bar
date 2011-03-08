class Car < ActiveRecord::Base

  attr_accessor :represent_on

  validates_presence_of :company_id
  validates_presence_of :name, :price


  belongs_to :company
  has_many :photos


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

end
