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

require 'test_helper'

class BannerLogTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
