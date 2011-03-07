class Applicant < ActiveRecord::Base

  belongs_to :event

  validates_presence_of :name, :address, :phone_number

end
