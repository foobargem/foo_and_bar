class RacingModelsController < ApplicationController

  def index
    scoped = RacingModel.published.where("photo_thumb_url is not null")

    @racing_models = scoped.
                      select("id, photo_thumb_url").
                      order("id DESC").
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

  def profiles
    @models = RacingModel.order("name asc")
    respond_to do |format|
      format.json { render :json => @models.to_json(:methods => :company_name) }
    end
  end

  def show
    @racing_model = RacingModel.find(params[:id])

    respond_to do |format|
      format.json { render :json => {
          :racing_model => @racing_model.attributes.merge(
            :career_desc => @racing_model.career_desc_to_html,
            :height_with_weight => @racing_model.height_with_weight,
            :photos_size => @racing_model.photos.size
          )
        }
      }
    end
  end

  def photos
    @racing_model = RacingModel.find(params[:id])
    @photos = @racing_model.photos.published

    respond_to do |format|
      format.json { render :json => @photos.to_json }
    end
  end

end
