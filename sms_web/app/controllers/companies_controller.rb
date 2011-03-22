class CompaniesController < ApplicationController

  def index
    scoped = Company.scoped
    scoped = case params[:category]
             when "component"
              scoped.component_part
             when "goods"
              scoped.goods_part
             when "has_models"
              car_ids = Photo.cars.select("car_id").map(&:car_id)
              company_ids = Car.where("id IN (?)", car_ids).select("company_id").map(&:company_id)
              scoped.where("id IN (?)", company_ids)
             else
              scoped.car_part
             end
    @companies = scoped.select("id, name, booth_code")

    respond_to do |format|
      format.json { render :json => @companies.to_json }
    end
  end

  def show
    raw_id = params[:id]
    @company = if raw_id.to_i > 0
                Company.find(params[:id])
               else
                Company.find_by_booth_code(params[:id])
               end

    unless @company.nil?
      respond_to do |format|
        format.json { render :json => @company.to_json }
      end
    else
      respond_to do |format|
        format.json { render :json => {}, :status => 404 }
      end
    end
  end

end
