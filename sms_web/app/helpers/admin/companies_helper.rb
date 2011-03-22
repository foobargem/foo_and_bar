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

  def display_company_name(company)
    unless company.nil?
      company.name
    else
      "-"
    end
  end

  def grouped_company_collection
    Company.select("id, name, category").all.group_by(&:category).map do |k, v|
      cate_name = case k
                  when "component"
                    "부품"
                  when "goods"
                    "용품"
                  else
                    "완성차"
                  end
      [cate_name, v.map{ |m| [m.name, m.id] }]
    end
  end

  def display_draft_status(published)
    if published
      "<span class=\"published\">Published</span>".html_safe
    else
      "<span class=\"unpublished\">Unpublished</span>".html_safe
    end
  end

  def display_company_flickr_image(c)
    unless c.logo_url.nil?
      image_tag c.logo_url, :size => "80x80"
    else
      "-"
    end
  end


end
