# == Schema Information
#
# Table name: events
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  status     :string(255)
#  opened_at  :datetime
#  closed_at  :datetime
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
