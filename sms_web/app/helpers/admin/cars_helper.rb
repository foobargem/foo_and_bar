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
    
    scoped.select("id, name").all.map do |company|
      [company.name, company.id]
    end
  end

end
