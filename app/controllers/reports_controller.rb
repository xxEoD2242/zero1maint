# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: %i[show a_service_calculation shock_service_calculation air_filter_calculation rzr_report tour_car_report other_vehicles_report work_order_defects_report]

  def index
    @reports = Report.all
    @q = Report.all.ransack(params[:q])
    @report_results = @q.result.page(params[:page])
  end

  def show
    @out_of_service = ReportVehicleOrder.where(vehicle_status: 'Out-of-Service', report_id: @report.id)
    @in_service = ReportVehicleOrder.where(vehicle_status: 'In-Service', report_id: @report.id)
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

  def weekly_work_order_reports
    @weekly_defect = Report.where(report_type: 'Weekly-Defect')
    @weekly_in_progress = Report.where(report_type: 'Weekly-New/In-Progress')
    @weekly_completed = Report.where(report_type: 'Weekly-Completed')
  end

  def weekly_vehicle_reports
    @weekly_rzr = Report.where(report_type: 'Weekly-RZR')
    @weekly_tour_car = Report.where(report_type: 'Weekly-Tour Car')
    @weekly_other = Report.where(report_type: 'Weekly-Other')
  end

  def rzr_report
    @q = Vehicle.are_rzr.ransack(params[:q])
    @rzrs = @q.result
    to_pdf "RZR Report for #{Date.current.strftime('%D')}"
  end

  def tour_car_report
    @q = Vehicle.where(veh_category: 'Tour Car').ransack(params[:q])
    @tour_cars = @q.result
    to_pdf "Tour Car Report for #{Date.current.strftime('%v')}"
  end

  def other_vehicles_report
    @q = Vehicle.where('veh_category != ? AND veh_category != ?', 'RZR', 'Tour Car').ransack(params[:q])
    @vehicles = @q.result
    to_pdf "Other Vehicle Report for #{Date.current.strftime('%v')}"
  end

  def checklist_report
    @q = Event.all.ransack(params[:q])
    @events = @q.result

    respond_to do |format|
      format.html
      format.xls
      format.pdf do
        render pdf: 'Checklist Report', layout: 'pdf.pdf.erb', title: "Checklist Report for #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
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
        render pdf: 'Defect Work Order Report', layout: 'pdf.pdf.erb', title: "Defect Work Order Report for #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
      end
    end
  end

  def work_order_report
    @requests = Request.where('created_at > ?', 1.month.ago)
    @new = @requests.where(status: 'New')
    @in_progress = @requests.where(status: 'In-Progress')
    @completed = @requests.where(status: 'Completed')
    @overdue = @requests.where(status: 'Overdue')
    respond_to do |format|
      format.html
      format.xls
      format.pdf do
        render pdf: 'All Work Orders Report', layout: 'pdf.pdf.erb', title: "All Work Orders Report for #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
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
        render pdf: 'New/In-Progress Work Order Report', layout: 'pdf.pdf.erb', title: "New/In-Progress Work Order Report for #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
      end
    end
  end

  def work_order_completed_report
    @requests = Request.where(status: 'Completed')
    @q = @requests.ransack(params[:q])
    @completed = @q.result
    to_pdf "Work Orders that are Completed for #{Date.current.strftime('%v')}"
  end
  
  def to_pdf(file_name)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: file_name,
               layout: 'pdf.pdf.erb',
               title: file_name
      end
    end
  end

  def dashboard
    @reports = Report.all
  end

  def new
    @report = Report.new
  end


  def edit; end

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

  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

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
    @set_a_service = Program.find_by(name: 'A-Service')
  end

  def set_shock_service
    @set_shock_service = Program.find_by(name: 'Shock Service')
  end

  def set_air_filter_service
    @set_air_filter_service = Program.find_by(name: 'Air Filter Change')
  end

  def set_repairs
    @set_repairs = Program.find_by(name: 'Repairs')
  end

  def set_defects
    @set_defects = Program.find_by(name: 'Defect')
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
