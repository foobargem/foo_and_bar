# == Schema Information
#
# Table name: photos
#
#  id                     :integer(4)      not null, primary key
#  large_url              :string(255)
#  thumb_url              :string(255)
#  image_raw_file_name    :string(255)
#  image_raw_content_type :string(255)
#  image_raw_file_size    :integer(4)
#  image_raw_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  company_id             :integer(4)
#  car_id                 :integer(4)
#  racing_model_id        :integer(4)
#  flickr_photo_id        :string(255)
#  flickr_photoset_id     :string(255)
#

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
