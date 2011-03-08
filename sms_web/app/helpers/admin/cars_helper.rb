# encoding: utf-8
module Admin::CarsHelper

  def company_collection(category)
    scoped = Company.scoped
    
    scoped = case category
             when "car"
              scoped.car_part
             when "component"
              scoped.component_part
             when "goods"
              scoped.goods_part
             end
    
    scoped.select("id, name").all.map do |company|
      [company.name, company.id]
    end
  end

  def display_company_name(car)
    unless car.company.nil?
      car.company.name
    else
      "삭제된 제조사"
    end
  end

end
