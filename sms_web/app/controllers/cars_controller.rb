class CarsController < ApplicationController

  def index
    scoped = Car.scoped

    if params[:company_id] && params[:company_id].to_i > 0
      scoped = scoped.where("cars.company_id = ?", params[:company_id])
    end

    @cars = scoped.
              where("companies.category = 'car'").joins(:company).
              includes(:photos).select("cars.id, cars.name").
              order("cars.name ASC")

    respond_to do |format|
      #format.json { render :json => @cars.to_json(:include => :photos) }
      format.json { render :json => @cars.to_json }
    end
  end

  def booth
    scoped = Car.scoped

    if params[:company_id] && params[:company_id].to_i > 0
      scoped = scoped.where("company_id = ?", params[:company_id])
    end
    
    if params[:booth_code_id]
      scoped = Company.where("booth_code = ?", params[:booth_code_id]).first.cars
    end
    
    @cars = scoped.select("cars.id, cars.name, cars.company_id").order("cars.name ASC")

    respond_to do |format|
      format.json { 
        render :json => {
          :cars => @cars,
          :companyname => @cars.first.company.name
          }.to_json
        }
    end
  
  end
  
  def show
    @car = Car.find(params[:id])

    respond_to do |format|
      format.json { render :json => {
          :car => @car.attributes.merge(
            :desc => @car.desc_to_html
          ),
          :company => @car.company
        }
      }
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
