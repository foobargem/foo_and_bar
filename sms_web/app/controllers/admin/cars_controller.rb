# encoding: utf-8
class Admin::CarsController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  #before_filter :flickr_authorized!

  def index
    @search = Car.search(params[:search])
    @cars = @search.
              includes(:company, :photos).
              order("id desc").
              paginate(:page => params[:page], :per_page => 20)
    store_params
  end

  def show
    @car = Car.find(params[:id])
  end

  def new
    @car = Car.new
  end

  def edit
    @car = Car.find(params[:id])
  end

  def create
    @car = Car.new(params[:car])

    if @car.save
      redirect_to admin_cars_path(stored_params)
    else
      render :action => "new"
    end
  end

  def update
    @car = Car.find(params[:id])

    if @car.update_attributes(params[:car])
      redirect_to admin_cars_path(stored_params)
    else
      render :action => "edit"
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy

    redirect_to admin_cars_path(stored_params)
  end


  def upload_to_flickr
    @car = Car.find(params[:id])
    @car.upload_image_to_flickr

    render :update do |page|
      page.replace dom_id(@car), :partial => "admin/cars/tr_car", :locals => { :car => @car }
    end
  end

  def batch_upload_to_flickr
    @cars = Car.
              where("image_raw_file_name is not null").
              where("photo_thumb_url is null or photo_large_url is null")
    @cars.each do |car|
      begin
        car.upload_image_to_flickr
      rescue Exception => e
        next
      end
    end

    render :update do |page|
      page.reload
    end
  end

  def export_to_excel
    @cars = Car.scoped
    columns = [
      { :company_id => "제조사" },
      { :name => "차명" },
      { :price => "가격" },
      { :vehicle_type => "차종" },
      { :engine_type => "엔진형식" },
      { :ventilation => "배기량" },
      { :fuel => "연료" },
      { :fuel_mileage => "연비" },
      { :peak_output => "최대출력" },
      { :seat_capacity => "승차인원" },
      { :drive_type => "구동방식" },
      { :transmission => "변속기" },
      { :video_stream_url => "영상URL" },
      { :desc => "설명" }
    ]

    associations = {
      :company_id => [:company, :name]
    }

    egt = Tools::ExcelGenerator.new("cars")
    egt.export_to_xls("cars", @cars, columns, associations)

    suffix = Time.zone.now.strftime("%Y%m%d_%H%M")
    download_filename = "CarsList-#{suffix}.xls"

    send_file(egt.output_file_path, {
      :filename => download_filename,
      :type => "application/vnd.ms-excel;charset=utf-8"
    })
  end

end
