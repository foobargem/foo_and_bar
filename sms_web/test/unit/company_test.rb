# == Schema Information
#
# Table name: companies
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(255)
#  category               :string(255)
#  contact                :string(255)
#  address                :string(255)
#  product                :string(255)
#  desc                   :text
#  site_url               :string(255)
#  logo_url               :string(255)
#  image_raw_file_name    :string(255)
#  image_raw_content_type :string(255)
#  image_raw_file_size    :integer(4)
#  image_raw_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  booth_code             :string(255)
#  flickr_photo_id        :string(255)
#  flickr_photoset_id     :string(255)
#

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
