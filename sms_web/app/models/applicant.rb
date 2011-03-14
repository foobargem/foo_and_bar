# == Schema Information
#
# Table name: applicants
#
#  id           :integer(4)      not null, primary key
#  event_id     :integer(4)
#  name         :string(255)
#  address      :string(255)
#  phone_number :string(255)
#  email        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Applicant < ActiveRecord::Base

  belongs_to :event, :counter_cache => true

  validates_presence_of :name, :address, :phone_number
  validates_uniqueness_of :phone_number, :scope => :event_id


  default_scope :order => "id DESC"

  protected

    def sanitize_phone_number
      self.phone_number = self.phone_number.gsub(/\D/, '')
    end
    before_save :sanitize_phone_number

end
