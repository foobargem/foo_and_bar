# == Schema Information
#
# Table name: racing_models
#
#  id                     :integer(4)      not null, primary key
#  company_id             :integer(4)
#  name                   :string(255)
#  birth                  :string(255)
#  blood_type             :string(255)
#  height                 :string(255)
#  weight                 :string(255)
#  dress_size             :string(255)
#  bwh                    :string(255)
#  shoe_size              :string(255)
#  hobby                  :string(255)
#  homepage_url           :string(255)
#  fan_site_url           :string(255)
#  career_desc            :text
#  photo_large_url        :string(255)
#  photo_thumb_url        :string(255)
#  image_raw_file_name    :string(255)
#  image_raw_content_type :string(255)
#  image_raw_file_size    :integer(4)
#  image_raw_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  flickr_photo_id        :string(255)
#  flickr_photoset_id     :string(255)
#

require 'test_helper'

class RacingModelTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
