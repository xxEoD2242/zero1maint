class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_vehicles, :in_service, :out_of_service, only: [:show, :a_service_calculation, :shock_service_calculation, :air_filter_calculation, :rzr_report]
  before_action :set_tracker, :set_new, :set_progress, :set_completed, :set_overdue, only: [:show, :a_service_calculation, :shock_service_calculation, :air_filter_calculation, :rzr_report]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: [:show, :a_service_calculation, :shock_service_calculation, :air_filter_calculation, :rzr_report]
  before_action :a_service_calculation, :shock_service_calculation, :air_filter_calculation, only: [:rzr_report, :show]
  
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
    @out_of_service = ReportVehicleOrder.where(vehicle_status: "Out-of-Service", report_id: @report.id)
    @in_service = ReportVehicleOrder.where(vehicle_status: "In-Service", report_id: @report.id)
  end
  
  def download
    @report = Report.find_by(params[:id])
    data = open("https://s3.us-east-2.amazonaws.com/zero1maintphotos/uploads/report/report_doc/1/#{@report.report_doc}") 
    send_data data.read, filename: "#{@report.report_doc}.pdf", type: "application/pdf", disposition: 'inline', stream: 'true', buffer_size: '4096' 
  end

  # @weekly = Report.where('created_at < ?', 1.week.ago)
  def weekly_reports
    @weekly = Report.where(report_type: "Weekly")
    @weekly_rzr = Report.where(report_type: "Weekly-RZR")
  end
  
  def rzr_report
    @rzr = VehicleCategory.find_by(name: "RZR")
    @out_of_service = Vehicle.where(vehicle_category_id: @rzr.id, vehicle_status: "Out-of-Service")
    @vehicles = Vehicle.where(vehicle_category_id: @rzr.id, vehicle_status: "In-Service")
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "RZR Report", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
         end
       end
  end
  
  def create_report
    respond_to do |format|
         format.html
         format.pdf do
           render pdf: params[:file_name]   # Excluding ".pdf" extension.
         end
    end
  end
  
  def defect_report
    
  end
  
  def in_progress_report
    
  end
  
  def completed_work_order_report
    
  end
  
  def a_service_calculation
    @vehicles.all.each do |vehicle|
      if vehicle.mileage != nil
      if vehicle.requests.where(program_id: @set_a_service.id, tracker_id: @set_completed.id) != []
    @a_service = (@set_a_service.interval - (vehicle.mileage - vehicle.requests.where(program_id: @set_a_service.id, tracker_id: @set_completed.id).last.request_mileage))
      end
      end
    end
  end
  
  def shock_service_calculation
    @vehicles.all.each do |vehicle|
      if vehicle.mileage != nil
      if vehicle.requests.where(program_id: @set_shock_service.id, tracker_id: @set_completed.id) != []
    @shock_service = (@set_shock_service.interval - (vehicle.mileage - vehicle.requests.where(program_id: @set_shock_service.id, tracker_id: @set_completed.id).last.request_mileage))
      end
      end
    end
  end
  
  def air_filter_calculation
    @vehicles.all.each do |vehicle|
      if vehicle.mileage != nil
      if vehicle.requests.where(program_id: @set_air_filter_service.id, tracker_id: @set_completed.id) != []
     @air_filter_service = (@set_air_filter_service.interval - (vehicle.mileage - vehicle.requests.where(program_id: @set_air_filter_service.id, tracker_id: @set_completed.id).last.request_mileage))
       end
       end
    end
  end
  
  def in_service
    @in_service = Vehicle.where(vehicle_status: "In-Service")
  end
  
  def out_of_service
    @out_of_service = Vehicle.where(vehicle_status: "Out-of-Service")
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
    
    def set_a_service
      @set_a_service = Program.find_by(name: "A-Service")
    end
    
    def set_shock_service
      @set_shock_service = Program.find_by(name: "Shock Service")
    end
    
    def set_air_filter_service
      @set_air_filter_service = Program.find_by(name: "Air Filter Change")
    end
    
    def set_repairs
      @set_repairs = Program.find_by(name: "Repairs")
    end
    
    def set_defects
      @set_defects = Program.find_by(name: "Defect")
    end
  
    def set_tracker
      @tracks = Tracker.all
    end
    
    def set_new
      @set_new = Tracker.find_by(track: "New")
    end
    
    def set_progress
      @set_progress = Tracker.find_by(track: "In-Progress")
    end
    
    def set_completed
      @set_completed = Tracker.find_by(track: "Completed")
    end
    
    def set_overdue
      @set_overdue = Tracker.find_by(track: "Overdue")
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
      params.require(:report).permit(:title, :description, :status, :info_vehicle, :report_type, :report_doc, vehicle_ids: [], request_ids: [], part_ids: [], event_ids: [], user_ids: [])
    end
end
