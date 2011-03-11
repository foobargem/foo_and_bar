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

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
