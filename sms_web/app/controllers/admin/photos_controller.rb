class Admin::PhotosController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!

  # GET /admin/photos
  # GET /admin/photos.xml
  def index
    @photos = Photo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
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
      redirect_to [:admin, @photo]
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
end
