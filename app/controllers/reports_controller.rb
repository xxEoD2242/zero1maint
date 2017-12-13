class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_action :set_vehicles, :in_service, :out_of_service, only: [:show, :a_service_calculation, :shock_service_calculation, :air_filter_calculation, :rzr_report, :tour_car_report, :other_vehicles_report]
  before_action :set_tracker, :set_new, :set_progress, :set_completed, :set_overdue, only: [:show, :a_service_calculation, :shock_service_calculation, :air_filter_calculation, :rzr_report, :work_order_completed_report, :work_order_in_progress_report, :weekly_work_order_reports, :weekly_vehicle_reports, :work_order_defects_report, :other_vehicles_report, :tour_car_report]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: [:show, :a_service_calculation, :shock_service_calculation, :air_filter_calculation, :rzr_report, :tour_car_report, :other_vehicles_report, :work_order_defects_report]
  
  
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
  
 # def download
 # @report = Report.find(params[:id])
 # Aws.config.update({
#  region: "#{ENV['S3_REGION']}",
 # credentials: Aws::Credentials.new("#{ENV['AWS_ACCESS_KEY_ID']}", "#{ENV['AWS_SECRET_ACCESS_KEY']}")
  #     })
  # s3 = Aws::S3::Resource.new
  # s3.bucket("#{ENV['S3_BUCKET_NAME']}").object(@report.report_doc.to_s).get(response_target: '/path/to/file')
#  end
  

  # @weekly = Report.where('created_at < ?', 1.week.ago)
  def weekly_work_order_reports
    @weekly_defect = Report.where(report_type: "Weekly-Defect")
    @weekly_in_progress = Report.where(report_type: "Weekly-New/In-Progress")
    @weekly_completed = Report.where(report_type: "Weekly-Completed")
  end
  
  def weekly_vehicle_reports
     @weekly_rzr = Report.where(report_type: "Weekly-RZR")
     @weekly_tour_car= Report.where(report_type: "Weekly-Tour Car")
     @weekly_other = Report.where(report_type: "Weekly-Other")
  end
  
  def rzr_report
   
    @q = Vehicle.where(veh_category: "RZR").ransack(params[:q])
    @rzrs = @q.result
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "RZR Report", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
         end
       end
  end
  
  def tour_car_report

    @q = Vehicle.where(veh_category: "Tour Car").ransack(params[:q])
    @tour_cars = @q.result
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "Tour Car Report", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
         end
    end
  end
  
  def other_vehicles_report
  
    
    @q = Vehicle.all.ransack(params[:q])
    @vehicles = @q.result
        
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "Other Vehicle Report", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
         end
       end
  end
  
  
  def work_order_defects_report
    @q = Request.where(program_id: @set_defects.id).ransack(params[:q])
    @work_orders = @q.result
    
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "Defect Work Order Report", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
         end
       end
  end
  
  def work_order_report
    @requests = Request.where('created_at > ?', 1.month.ago)
    @new = @requests.where(tracker_id: @set_new.id)
    @in_progress = @requests.where(tracker_id: @set_progress.id)
    @completed = @requests.where(tracker_id: @set_completed.id)
    @overdue = @requests.where(tracker_id: @set_overdue.id)
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "All Work Orders Report", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
         end
       end
  end
  
  def work_order_in_progress_report
    @q = Request.all.ransack(params[:q])
    @work_orders = @q.result
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "New/In-Progress Work Order Reports", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
         end
       end
  end
  
  def work_order_completed_report
    @set_completed = Tracker.find_by(track: "Completed")
    @requests = Request.where(tracker_id: @set_completed.id)
    @q = @requests.ransack(params[:q])
    @completed = @q.result
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "Completed Work Order Reports", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
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
