# encoding: utf-8
class Admin::ApplicantsController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!
  before_filter :find_event

  # GET /admin/applicants
  # GET /admin/applicants.xml
  def index
    @applicants = @event.applicants.paginate(:page => params[:page], :per_page => 30)
  end

  # GET /admin/applicants/1
  # GET /admin/applicants/1.xml
  def show
    @applicant = @event.applicants.find(params[:id])
  end

  # GET /admin/applicants/new
  # GET /admin/applicants/new.xml
  def new
    @applicant = Applicant.new
  end

  # GET /admin/applicants/1/edit
  def edit
    @applicant = @event.applicants.find(params[:id])
  end

  # POST /admin/applicants
  # POST /admin/applicants.xml
  def create
    @applicant = Applicant.new(params[:applicant])

    if @applicant.save
      redirect_to [:admin, @event, :applicants]
    else
      render :action => "new"
    end
  end

  # PUT /admin/applicants/1
  # PUT /admin/applicants/1.xml
  def update
    @applicant = Applicant.find(params[:id])

    if @applicant.update_attributes(params[:applicant])
      redirect_to [:admin, @event, :applicants]
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/applicants/1
  # DELETE /admin/applicants/1.xml
  def destroy
    @applicant = @event.applicants.find(params[:id])
    @applicant.destroy

    redirect_to [:admin, @event, :applicants]
  end

  def export_to_excel
    @applicants = @event.applicants.order("id ASC")
    columns = [
      { :name => "이름" },
      { :phone_number => "연락처" },
      { :address => "주소" },
      { :created_at => "응모일" },
      { :user_agent => "사용기기" }
    ]

    associations = {
    }

    egt = Tools::ExcelGenerator.new("applicants")
    egt.export_to_xls("applicants", @applicants, columns, associations)

    suffix = Time.zone.now.strftime("%Y%m%d_%H%M")
    download_filename = "ApplicantsList-#{suffix}.xls"

    send_file(egt.output_file_path, {
      :filename => download_filename,
      :type => "application/vnd.ms-excel;charset=utf-8"
    })
  end

  protected
  
    def find_event
      @event = Event.find(params[:event_id])
    end

end
