class PhotosController < ApplicationController

  def index
    scoped = Photo.scoped

    category = params[:category] || nil
    scoped = case category
             when "car"
              scoped.cars
             when "racing_model"
              #scoped.racing_models
              return models
             else
              scoped.without_car_and_racing_model
             end

    @photos = scoped.
      select("id, car_id, racing_model_id, thumb_url").
      paginate(:page => params[:page], :per_page => 20)

    last_photo = scoped.last

    has_next = (last_photo.nil? || @photos.last.id == last_photo.id) ? "n" : "y"

    respond_to do |format|
      format.json { render :json => {
          :photos => @photos,
          :has_next => has_next
        }.to_json
      }
    end
  end


  def models_by_company
    company = Company.find(params[:company_id])

    car_ids = company.cars.select("id").map(&:id)
    scoped = Photo.with_car_and_racing_model.where("car_id in (?)", car_ids)

    @photos = scoped.
                select("id, racing_model_id, thumb_url")
                #paginate(:page => params[:page], :per_page => 20)

    #last_photo = scoped.last
    #has_next = (last_photo.nil? || @photos.last.id == last_photo.id) ? "n" : "y"

    respond_to do |format|
      format.json { render :json => @photos.to_json }
    end
  end

  def by_company_booth_code
    company = Company.find_by_booth_code(params[:booth_code])
    car_ids = company.cars.select("id").map(&:id)
    scoped = Photo.cars.where("car_id in (?)", car_ids)

    @photos = scoped.select("id, car_id, thumb_url").
      paginate(:page => params[:page], :per_page => 20)

    last_photo = scoped.last

    has_next = (last_photo.nil? || @photos.last.id == last_photo.id) ? "n" : "y"

    respond_to do |format|
      format.json { render :json => {
          :company => { :name => company.name, :id => company.id },
          :photos => @photos,
          :has_next => has_next
        }.to_json
      }
    end
  end

  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.json { render :json => @photo.to_json }
    end
  end


  protected

    def models
      scoped = RacingModel.scoped

      @racing_models = scoped.
                        select("id, photo_thumb_url").
                        paginate(:page => params[:page], :per_page => 20)

      last_model = scoped.last

      has_next = (last_model.nil? || @racing_models.last.id == last_model.id) ? "n" : "y"

      photos = []
      @racing_models.each do |racing_model|
        photos << { "photo" => {
            "racing_model_id" => racing_model.id,
            "thumb_url" => racing_model.photo_thumb_url
          }
        }
      end

      respond_to do |format|
        format.json { render :json => {
            :photos => photos,
            :has_next => has_next
          }.to_json
        }
      end
    end

end
