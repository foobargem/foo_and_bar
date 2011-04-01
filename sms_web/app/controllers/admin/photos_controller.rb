class Admin::PhotosController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  before_filter :flickr_authorized!,
                :only => [:upload_to_flickr, :batch_upload_to_flickr]

  # GET /admin/photos
  # GET /admin/photos.xml
  def index
    scoped = Photo.scoped
    scoped = if params[:car_id]
              scoped.where("car_id = ?", params[:car_id])
             elsif params[:racing_model_id]
              scoped.where("racing_model_id = ?", params[:racing_model_id])
             else
              scoped
             end
    @photos = scoped.
                includes(:car, :racing_model).
                paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/photos/1
  # GET /admin/photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /admin/photos/new
  # GET /admin/photos/new.xml
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /admin/photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /admin/photos
  # POST /admin/photos.xml
  def create
    @photo = Photo.new(params[:photo])

    if @photo.save
      redirect_to [:admin, :photos]
    else
      render :action => "new"
    end
  end

  # PUT /admin/photos/1
  # PUT /admin/photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    if @photo.update_attributes(params[:photo])
      redirect_to [:admin, :photos]
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/photos/1
  # DELETE /admin/photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    redirect_to [:admin, :photos]
  end


  def upload_to_flickr
    @photo = Photo.find(params[:id])
    @photo.upload_image_to_flickr

    render :update do |page|
      page.replace dom_id(@photo), :partial => "admin/photos/tr_photo", :locals => { :photo => @photo }
    end
  end


  def batch_upload_to_flickr
    @photos = Photo.
                where("image_raw_file_name is not null").
                where("thumb_url is null or large_url is null")
    @photos.each do |photo|
      begin
        photo.upload_image_to_flickr
      rescue Exception => e
        next
      end
    end

    render :update do |page|
      page.reload
    end
  end

end
