class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :a_service_calculation, :shock_service_calculation, :air_filter_service_calculation, only: [:rzr_report, :show]
  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
    @q = Report.all.ransack(params[:q])
    @report_results = @q.result.page(params[:page])
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end
  
  def rzr_report
    
  end
  
  def defect_report
    
  end
  
  def in_progress_report
    
  end
  
  def work_order_complete_report
    
  end
  
  def a_service_calculation
    @vehicles.all.each do |vehicle|
      if vehicle.mileage != nil
      if vehicle.requests.where(program_id: @set_a_service.id, tracker_id: @set_completed.id) != []
    @a_service = (@set_a_service.interval - (vehicle.mileage - vehicle.requests.where(program_id: @set_a_service.id, tracker_id: 3).last.request_mileage))
  end
end
end
  end
  
  def shock_service_calculation
    @vehicles.all.each do |vehicle|
      if vehicle.mileage != nil
      if vehicle.requests.where(program_id: @set_shock_service.id, tracker_id: @set_completed.id) != []
    @shock_service = (@set_shock_service.interval - (vehicle.mileage - vehicle.requests.where(program_id: @set_shock_service.id, tracker_id: 3).last.request_mileage))
  end
end
end
  end
  
  def air_filter_calculation
    
    @vehicles.all.each do |vehicle|
      if vehicle.mileage != nil
      if vehicle.requests.where(program_id: @set_air_filter_service.id, tracker_id: @set_completed.id) != []
     @air_filter_service = (@set_air_filter_service.interval - (vehicle.mileage - vehicle.requests.where(@set_air_filter_service.id, tracker_id: 3).last.request_mileage))
   end
 end
end
  end
  
  def dashboard
    @reports = Report.all
  end

  # GET /reports/new
  def new
    @report = Report.new
    @vehicle_categories = VehicleCategory.all
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end
    
    def set_vehicles
      @vehicles = Vehicle.all
    end
    
    def set_requests
      @requests = Request.all
    end
    
    def set_parts
      @parts = Part.all
    end
    
    def set_events
      @events = Event.all
    end
    
    def set_user
      @users = User.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:title, :description, :status, :report_type, :user_id, vehicle_ids: [], request_ids: [], part_ids: [], event_ids: [], user_ids: [])
    end
end
