class Admin::RacingModelsController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  #before_filter :flickr_authorized!

  def index
    @search = RacingModel.
                includes(:company, :photos).
                search(params[:search])
    @racing_models = @search.paginate(:page => params[:page], :per_page => 20)
    store_params
  end

  def show
    @racing_model = RacingModel.find(params[:id])
  end

  def new
    @racing_model = RacingModel.new
  end

  def edit
    @racing_model = RacingModel.find(params[:id])
  end

  def create
    @racing_model = RacingModel.new(params[:racing_model])

    if @racing_model.save
      redirect_to admin_racing_models_path(stored_params)
    else
      render :action => "new"
    end
  end

  def update
    @racing_model = RacingModel.find(params[:id])

    if @racing_model.update_attributes(params[:racing_model])
      redirect_to admin_racing_models_path(stored_params)
    else
      render :action => "edit"
    end
  end

  def destroy
    @racing_model = RacingModel.find(params[:id])
    @racing_model.destroy

    redirect_to admin_racing_models_path(stored_path)
  end


  def upload_to_flickr
    @racing_model = RacingModel.find(params[:id])
    @racing_model.upload_image_to_flickr

    render :update do |page|
      page.replace dom_id(@racing_model), :partial => "admin/racing_models/tr_racing_model", :locals => { :racing_model => @racing_model }
    end
  end

  def batch_upload_to_flickr
    @racing_models = RacingModel
                      .where("image_raw_file_name is not null")
                      .where("photo_thumb_url is null or photo_large_url is null")
    @racing_models.each do |racing_model|
      begin
        racing_model.upload_image_to_flickr
      rescue Exception => e
        next
      end
    end

    render :update do |page|
      page.reload
    end
  end

end
