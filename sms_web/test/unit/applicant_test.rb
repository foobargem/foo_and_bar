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
#  user_agent   :string(255)
#

require 'test_helper'

class ApplicantTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
