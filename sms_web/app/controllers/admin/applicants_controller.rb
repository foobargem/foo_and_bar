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


  protected
  
    def find_event
      @event = Event.find(params[:event_id])
    end

end
