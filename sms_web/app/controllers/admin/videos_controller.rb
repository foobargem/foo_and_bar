class Admin::VideosController < ApplicationController

  layout "admin"

  # GET /admin/videos
  # GET /admin/videos.xml
  def index
    @videos = Video.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
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
      redirect_to [:admin, @video]
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
