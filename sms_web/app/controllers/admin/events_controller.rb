class Admin::EventsController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!

  # GET /admin/events
  # GET /admin/events.xml
  def index
    @events = Event.all
  end

  # GET /admin/events/1
  # GET /admin/events/1.xml
  def show
    @event = Event.find(params[:id])
  end

  # GET /admin/events/new
  # GET /admin/events/new.xml
  def new
    @event = Event.new
  end

  # GET /admin/events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /admin/events
  # POST /admin/events.xml
  def create
    @event = Event.new(params[:event])

    if @event.save
      redirect_to [:admin, :events]
    else
      render :action => "new"
    end
  end

  # PUT /admin/events/1
  # PUT /admin/events/1.xml
  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(params[:event])
      redirect_to [:admin, :events]
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/events/1
  # DELETE /admin/events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    redirect_to [:admin, :events]
  end
end
