# == Schema Information
#
# Table name: videos
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  stream_url :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Video < ActiveRecord::Base

  default_scope :order => "title ASC"

end
