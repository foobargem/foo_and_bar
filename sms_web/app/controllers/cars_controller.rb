class CarsController < ApplicationController

  def index
    scoped = Car.scoped

    if params[:company_id] && params[:company_id].to_i > 0
      scoped = scoped.where("company_id = ?", params[:company_id])
    end

    @cars = scoped.includes(:photos).select("cars.id")

    respond_to do |format|
      format.json { render :json => @cars.to_json(:include => :photos) }
    end
  end

  def show
    @car = Car.find(params[:id])

    respond_to do |format|
      format.json { render :json => @car.to_json }
    end
  end

end
