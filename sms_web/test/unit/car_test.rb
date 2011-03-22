# == Schema Information
#
# Table name: cars
#
#  id                     :integer(4)      not null, primary key
#  company_id             :integer(4)
#  name                   :string(255)
#  price                  :string(255)
#  vehicle_type           :string(255)
#  engine_type            :string(255)
#  ventilation            :string(255)
#  fuel                   :string(255)
#  fuel_mileage           :string(255)
#  peak_output            :string(255)
#  seat_capacity          :string(255)
#  drive_type             :string(255)
#  transmission           :string(255)
#  voice_stream_url       :string(255)
#  video_stream_url       :string(255)
#  represented_at         :datetime
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
#  desc                   :text
#

require 'test_helper'

class CarTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
