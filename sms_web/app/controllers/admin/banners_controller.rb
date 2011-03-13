class Admin::BannersController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!

  def index
    @banners = Banner.all
  end

  def show
    @banner = Banner.find(params[:id])
  end

  def new
    @banner = Banner.new
  end

  def edit
    @banner = Banner.find(params[:id])
  end

  def create
    @banner = Banner.new(params[:banner])

    if @banner.save
      redirect_to [:admin, :banners]
    else
      render :action => "new"
    end
  end

  def update
    @banner = Banner.find(params[:id])

    if @banner.update_attributes(params[:banner])
      redirect_to [:admin, :banners]
    else
      render :action => "edit"
    end
  end

  def destroy
    @banner = Banner.find(params[:id])
    @banner.destroy

    redirect_to [:admin, :banners]
  end

end
