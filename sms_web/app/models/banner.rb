class Banner < ActiveRecord::Base

  default_scope :order => "id DESC"

  def embed_code
    code = "<a href=\"#{self.landing_url}\" target=\"_blank\">#{content}</a>"
    code
  end

end
