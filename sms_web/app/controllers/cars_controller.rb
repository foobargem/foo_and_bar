class CarsController < ApplicationController

  def index
    scoped = Car.scoped

    if params[:company_id] && params[:company_id].to_i > 0
      scoped = scoped.where("company_id = ?", params[:company_id])
    end

    @cars = scoped.includes(:photos).select("cars.id, cars.name")

    respond_to do |format|
      format.json { render :json => @cars.to_json(:include => :photos) }
    end
  end

  def show
    @car = Car.find(params[:id])

    respond_to do |format|
      format.json { render :json => @car.to_json(:include => :company) }
    end
  end
  
  def photos
    @car = Car.find(params[:id])
    
    scoped = @car.photos.published
    
    @photos = scoped.select("id, car_id, large_url, thumb_url").paginate(:page => params[:page], :per_page => 20)

    last_photo = scoped.last

    has_next = (last_photo.nil? || @photos.last.id == last_photo.id) ? "n" : "y"
    
    respond_to do |format|
      format.json { 
        render :json => { 
          :name => @car.name,
          :company => @car.company,
          :photos => @photos, 
          :has_next => has_next 
          }.to_json
        }
    end
  end
  
end
