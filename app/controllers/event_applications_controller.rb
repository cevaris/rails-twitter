class EventApplicationsController < ApplicationController
  before_action :set_event_application, only: [:show, :edit, :update, :destroy]

  # GET /event_applications
  # GET /event_applications.json
  def index
    @event_applications = EventApplication.all
  end

  # GET /event_applications/1
  # GET /event_applications/1.json
  def show
  end

  # GET /event_applications/new
  def new
    @event_application = EventApplication.new
  end

  # GET /event_applications/1/edit
  def edit
  end

  # POST /event_applications
  # POST /event_applications.json
  def create
    @event_application = EventApplication.new(event_application_params)

    respond_to do |format|
      if @event_application.save
        format.html { redirect_to @event_application, notice: 'Event application was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event_application }
      else
        format.html { render action: 'new' }
        format.json { render json: @event_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_applications/1
  # PATCH/PUT /event_applications/1.json
  def update
    respond_to do |format|
      if @event_application.update(event_application_params)
        format.html { redirect_to @event_application, notice: 'Event application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_applications/1
  # DELETE /event_applications/1.json
  def destroy
    @event_application.destroy
    respond_to do |format|
      format.html { redirect_to event_applications_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_application
      @event_application = EventApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_application_params
      params.require(:event_application).permit(:name)
    end
end
