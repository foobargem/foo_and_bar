module Admin::RacingModelsHelper

  def display_racing_model_flickr_image(r)
    unless r.photo_thumb_url.nil?
      image_tag r.photo_thumb_url, :size => "80x80"
    else
      "-"
    end
  end

end
