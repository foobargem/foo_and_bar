# == Schema Information
#
# Table name: banner_logs
#
#  id         :integer(4)      not null, primary key
#  banner_id  :integer(4)
#  action     :string(255)
#  user_agent :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class BannerLog < ActiveRecord::Base

  belongs_to :banner

end
