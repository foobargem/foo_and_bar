class Admin::CarsController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!

  # GET /admin/cars
  # GET /admin/cars.xml
  def index
    @cars = Car.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cars }
    end
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
      redirect_to admin_cars_path
    else
      render :action => "new"
    end
  end

  # PUT /admin/cars/1
  # PUT /admin/cars/1.xml
  def update
    @car = Car.find(params[:id])

    if @car.update_attributes(params[:car])
      redirect_to [:admin, @car]
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/cars/1
  # DELETE /admin/cars/1.xml
  def destroy
    @car = Car.find(params[:id])
    @car.destroy

    redirect_to admin_cars_path
  end
end
