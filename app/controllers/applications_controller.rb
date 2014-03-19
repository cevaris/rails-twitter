class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :edit, :update, :destroy]
  before_action :is_logged_in

  def is_logged_in
    redirect_to new_user_session_path if current_user.nil? 
  end

  # GET /applications
  # GET /applications.json
  def index
    @applications = current_user.applications
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    @application = Application.find(params[:id])
  end

  # GET /applications/1
  # GET /applications/1.json
  def show_bucket
    @application = Application.find(params[:id])
    @bucket = params[:bucket]
    @metric = Metric.find_by(application_id: @application.id, bucket: @bucket)

    respond_to do |format|
      format.html { render 'show_bucket' }
      format.json { render action: 'show_bucket', location: @application }
    end
    
  end

  # GET /applications/new
  def new
    @application = Application.new
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = Application.new(application_params)
    @application.user = current_user


    respond_to do |format|
      if @application.save
        format.html { redirect_to @application, notice: 'Event application was successfully created.' }
        format.json { render action: 'show', status: :created, location: @application }
      else
        format.html { render action: 'new' }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applications/1
  # PATCH/PUT /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to @application, notice: 'Event application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application.destroy
    respond_to do |format|
      format.html { redirect_to applications_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def application_params
      params.require(:application).permit(:name, :user)
    end
end
