class Admin::CompaniesController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  #before_filter :flickr_authorized!

  # GET /admin/companies
  # GET /admin/companies.xml
  def index
    @companies = Company.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_companies }
    end
  end

  # GET /admin/companies/1
  # GET /admin/companies/1.xml
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /admin/companies/new
  # GET /admin/companies/new.xml
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @company }
    end
  end

  # GET /admin/companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end

  # POST /admin/companies
  # POST /admin/companies.xml
  def create
    @company = Company.new(params[:company])

    if @company.save
      redirect_to [:admin, :companies]
    else
      render :action => "new"
    end
  end

  # PUT /admin/companies/1
  # PUT /admin/companies/1.xml
  def update
    @company = Company.find(params[:id])

    if @company.update_attributes(params[:company])
      redirect_to [:admin, :companies]
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/companies/1
  # DELETE /admin/companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    redirect_to [:admin, :companies]
  end


  def upload_to_flickr
    @company = Company.find(params[:id])
    @company.upload_image_to_flickr

    render :update do |page|
    end
  end

end
