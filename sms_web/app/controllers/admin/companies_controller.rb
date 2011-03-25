class Admin::CompaniesController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  #before_filter :flickr_authorized!

  def index
    @search = Company.search(params[:search])
    @companies = @search.order("id DESC").paginate(:page => params[:page], :per_page => 20)
    store_params
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def edit
    @company = Company.find(params[:id])
  end

  def create
    @company = Company.new(params[:company])

    if @company.save
      redirect_to admin_companies_path(stored_params)
    else
      render :action => "new"
    end
  end

  # PUT /admin/companies/1
  # PUT /admin/companies/1.xml
  def update
    @company = Company.find(params[:id])

    if @company.update_attributes(params[:company])
      redirect_to admin_companies_path(stored_params)
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/companies/1
  # DELETE /admin/companies/1.xml
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    redirect_to admin_companies_path(stored_params)
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
                    where("logo_url is null")
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
