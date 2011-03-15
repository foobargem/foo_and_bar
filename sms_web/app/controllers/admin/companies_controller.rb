class Admin::CompaniesController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  #before_filter :flickr_authorized!

  # GET /admin/companies
  # GET /admin/companies.xml
  def index
    @companies = Company.scoped.paginate(:page => params[:page], :per_page => 20)
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
      page.replace dom_id(@company), :partial => "admin/companies/tr_company", :locals => { :company => @company }
    end
  end

  def batch_upload_to_flickr
    @companies = Company.
                    where("image_raw_file_name is not null").
                    where("photo_thumb_url is null or photo_large_url is null")
    @companies.each do |company|
      begin
        company.upload_image_to_flickr
      rescue Exception => e
        next
      end
    end

    render :update do |page|
      page.reload
    end
  end
end
