class EventsController < ApplicationController

  # ToDo: remove
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

end
