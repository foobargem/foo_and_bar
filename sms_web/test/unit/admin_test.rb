# == Schema Information
#
# Table name: admins
#
#  id                 :integer(4)      not null, primary key
#  email              :string(255)     default(""), not null
#  encrypted_password :string(128)     default(""), not null
#  sign_in_count      :integer(4)      default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  login              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
