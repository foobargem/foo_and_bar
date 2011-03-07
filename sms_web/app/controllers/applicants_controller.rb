class ApplicantsController < ApplicationController

  before_filter :find_event


  def new
    @applicant = Applicant.new
  end

  def create
    @applicant = Applicant.new(params[:applicant])
    if @applicant.save
      redirect_to root_path
    else
      render :action => :new
    end
  end


  protected

    def find_event
      @event = Event.find(params[:event_id])
    end

end
