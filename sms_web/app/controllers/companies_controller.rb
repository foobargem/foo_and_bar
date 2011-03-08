class CompaniesController < ApplicationController

  def index
    scoped = Company.scoped
    scoped = case params[:category]
             when "component"
              scoped.component_part
             when "goods"
              scoped.good_part
             else
              scoped.car_part
             end
    @companies = scoped.select("id, name")

    respond_to do |format|
      format.json { render :json => @companies.to_json }
    end
  end

  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.json { render :json => @company.to_json }
    end
  end

end
