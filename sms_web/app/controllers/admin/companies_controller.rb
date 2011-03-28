# encoding: utf-8
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

  def export_to_excel
    @companies = Company.scoped
    columns = [
      { :name => "업체명" },
      { :category => "참가분야" },
      { :booth_code => "부스번호" },
      { :contact => "연락처" },
      { :address => "주소" },
      { :product => "출품" },
      { :site_url => "사이트URL" },
      { :desc => "설명" }
    ]

    associations = {
    }

    egt = Tools::ExcelGenerator.new("cars")
    egt.export_to_xls([
      { :sheet_name => "완성차", :collection => @companies.car_part.order("booth_code ASC"), :columns => columns, :assocs => associations},
      { :sheet_name => "부품업체", :collection => @companies.component_part.order("booth_code ASC"), :columns => columns, :assocs => associations},
      { :sheet_name => "용품업체", :collection => @companies.goods_part.order("booth_code ASC"), :columns => columns, :assocs => associations}
    ])

    suffix = Time.zone.now.strftime("%Y%m%d_%H%M")
    download_filename = "CompaniesList-#{suffix}.xls"

    send_file(egt.output_file_path, {
      :filename => download_filename,
      :type => "application/vnd.ms-excel;charset=utf-8"
    })
  end

end
