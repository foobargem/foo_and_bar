class Admin::VideosController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  before_filter :flickr_authorized!

  # GET /admin/videos
  # GET /admin/videos.xml
  def index
    @videos = Video.scoped.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/videos/1
  # GET /admin/videos/1.xml
  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /admin/videos/new
  # GET /admin/videos/new.xml
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /admin/videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /admin/videos
  # POST /admin/videos.xml
  def create
    @video = Video.new(params[:video])

    if @video.save
      redirect_to [:admin, :videos]
    else
      render :action => "new"
    end
  end

  # PUT /admin/videos/1
  # PUT /admin/videos/1.xml
  def update
    @video = Video.find(params[:id])

    if @video.update_attributes(params[:video])
      redirect_to [:admin, :videos]
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/videos/1
  # DELETE /admin/videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    redirect_to [:admin, :videos]
  end
end
