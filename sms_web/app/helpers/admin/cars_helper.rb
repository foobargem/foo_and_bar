# encoding: utf-8
module Admin::CarsHelper

  def company_collection(category = nil)
    scoped = Company.scoped
    
    scoped = case category
             when "car"
              scoped.car_part
             when "component"
              scoped.component_part
             when "goods"
              scoped.goods_part
             else
              scoped
             end
    
    scoped.select("id, name").order("name ASC").all.map do |company|
      [company.name, company.id]
    end
  end

  def display_car_flickr_image(c)
    unless c.photo_thumb_url.nil?
      image_tag c.photo_thumb_url, :size => "80x80"
    else
      "-"
    end
  end


end
