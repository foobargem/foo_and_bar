class Admin::RacingModelsController < ApplicationController

  layout "admin"
  before_filter :authenticate_admin!

  # GET /admin/racing_models
  # GET /admin/racing_models.xml
  def index
    @racing_models = RacingModel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @racing_models }
    end
  end

  # GET /admin/racing_models/1
  # GET /admin/racing_models/1.xml
  def show
    @racing_model = RacingModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @racing_model }
    end
  end

  # GET /admin/racing_models/new
  # GET /admin/racing_models/new.xml
  def new
    @racing_model = RacingModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @racing_model }
    end
  end

  # GET /admin/racing_models/1/edit
  def edit
    @racing_model = RacingModel.find(params[:id])
  end

  # POST /admin/racing_models
  # POST /admin/racing_models.xml
  def create
    @racing_model = RacingModel.new(params[:racing_model])

    if @racing_model.save
      redirect_to [:admin, :racing_models]
    else
      render :action => "new"
    end
  end

  # PUT /admin/racing_models/1
  # PUT /admin/racing_models/1.xml
  def update
    @racing_model = RacingModel.find(params[:id])

    if @racing_model.update_attributes(params[:racing_model])
      redirect_to [:admin, @racing_model]
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/racing_models/1
  # DELETE /admin/racing_models/1.xml
  def destroy
    @racing_model = RacingModel.find(params[:id])
    @racing_model.destroy

    redirect_to [:admin, :racing_models]
  end
end
