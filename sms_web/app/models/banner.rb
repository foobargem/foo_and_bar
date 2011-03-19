# == Schema Information
#
# Table name: banners
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  content     :text
#  landing_url :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Banner < ActiveRecord::Base

  default_scope :order => "id DESC"

  def embed_code
    code = "<a href=\"#{self.click_tracking_url}\" target=\"_blank\">#{content}#{impression_tracking_code}</a>"
    code
  end

  def click_tracking_url
    "#{SITE_URL}/tracking/click?bid=#{self.id}"
  end

  protected

    def impression_tracking_code
      url = "#{SITE_URL}/tracking/impr?bid=#{self.id}"
      "<img src=\"#{url}\" style=\"width:0px;height:0px;display:none\" />"
    end


end
