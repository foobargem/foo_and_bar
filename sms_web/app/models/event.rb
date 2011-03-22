# == Schema Information
#
# Table name: events
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  status           :string(255)
#  opened_at        :datetime
#  closed_at        :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  applicants_count :integer(4)
#

class Event < ActiveRecord::Base

  has_many :applicants, :dependent => :nullify

end
