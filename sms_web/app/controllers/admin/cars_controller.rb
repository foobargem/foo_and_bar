# encoding: utf-8
class Admin::CarsController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  #before_filter :flickr_authorized!

  # GET /admin/cars
  # GET /admin/cars.xml
  def index
    @cars = Car.scoped.paginate(:page => params[:page], :per_page => 20)
  end

  # GET /admin/cars/1
  # GET /admin/cars/1.xml
  def show
    @car = Car.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @car }
    end
  end

  # GET /admin/cars/new
  # GET /admin/cars/new.xml
  def new
    @car = Car.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @car }
    end
  end

  # GET /admin/cars/1/edit
  def edit
    @car = Car.find(params[:id])
  end

  # POST /admin/cars
  # POST /admin/cars.xml
  def create
    @car = Car.new(params[:car])

    if @car.save
      redirect_to [:admin, :cars]
    else
      render :action => "new"
    end
  end

  # PUT /admin/cars/1
  # PUT /admin/cars/1.xml
  def update
    @car = Car.find(params[:id])

    if @car.update_attributes(params[:car])
      redirect_to [:admin, :cars]
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/cars/1
  # DELETE /admin/cars/1.xml
  def destroy
    @car = Car.find(params[:id])
    @car.destroy

    redirect_to [:admin, :cars]
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
