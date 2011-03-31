module Admin::PhotosHelper

  def racing_model_collection
    RacingModel.select("id, name").order("name ASC").all.map do |m|
      [m.name, m.id]
    end
  end

  def car_collection
    Car.select("id, name").order("name ASC").all.map do |c|
      [c.name, c.id]
    end
  end

  def display_photo_car_info(photo)
    unless photo.car.nil?
      link_to photo.car.name, edit_admin_car_path(photo.car)
    else
      "-"
    end
  end

  def display_photo_racing_model_info(photo)
    unless photo.racing_model.nil?
      link_to photo.racing_model.name, edit_admin_racing_model_path(photo.racing_model)
    else
      "-"
    end
  end

  def display_photo_flickr_image(p)
    unless p.thumb_url.nil?
      image_tag p.thumb_url, :size => "80x80"
    else
      "-"
    end
  end

end
