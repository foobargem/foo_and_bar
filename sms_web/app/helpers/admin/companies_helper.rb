# encoding: utf-8
module Admin::CompaniesHelper

  def category_collection
    [["완성차", "car"], ["부품", "component"], ["용품", "goods"]]
  end

  def display_category_name(category)
    case category
    when "car"
      "완성차"
    when "component"
      "부품"
    when "goods"
      "용품"
    end
  end

end
