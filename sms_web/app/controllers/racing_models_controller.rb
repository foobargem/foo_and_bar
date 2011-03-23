class RacingModelsController < ApplicationController

  def index
    scoped = RacingModel.published

    if params[:company_id] && params[:company_id].to_i > 0
      scoped = scoped.where("company_id = ?", params[:company_id])
    end

    @racing_models = scoped.select("id, photo_thumb_url").includes(:photos)

    respond_to do |format|
      format.json { render :json => @racing_models.to_json(:include => :photos ) }
    end
  end

  def show
    @racing_model = RacingModel.find(params[:id])

    respond_to do |format|
      format.json { render :json => @racing_model.to_json }
    end
  end

end
