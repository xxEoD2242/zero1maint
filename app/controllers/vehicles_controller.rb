# frozen_string_literal: true

class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show edit update destroy]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: %i[a_service_calculation index mileage_calculation shock_service_calculation air_filter_calculation show needs_service near_service_required all_vehicles vehicle_mileage out_of_service]
  before_action :set_tracker, :set_new, :set_progress, :set_completed, :set_overdue, only: %i[a_service_calculation index mileage_calculation shock_service_calculation air_filter_calculation show needs_service near_service_required all_vehicles]
  before_action :set_all_vehicles, :in_service, :out_of_service, only: %i[a_service_calculation index mileage_calculation shock_service_calculation air_filter_calculation show needs_service near_service_required all_vehicles]
  before_action :mileage_calculation, only: %i[near_service_required needs_service]
  include Vehicle_Rotation

  def index
    @vehicles = Vehicle.all
    @request = Request.all
  end

  def sold_vehicles
    @q = Vehicle.where(vehicle_status: 'Sold').ransack(params[:q])
    @vehicle_results = @q.result.page(params[:page])
  end

  def import
    Vehicle.import(params[:file])
    redirect_to root_url, notice: 'Activity Data Imported!'
  end

  def vehicle_mileage
    @vehicle = Vehicle.find(params[:id])
    @events = @vehicle.events.where('date >= ?', Time.now - 1.year).page(params[:page])
    @events_month = @vehicle.events.where('date >= ?', Time.now - 1.month)
    @ytd_mileage = 0
    @mtd_mileage = 0
    @events.all.each do |event|
      @ytd_mileage += event.event_mileage
    end
    @events_month.all.each do |event|
      @mtd_mileage += event.event_mileage
    end
    @times_used = @events.all.count
    @times_used_month = @events_month.all.count
    @last_a_service = @vehicle.requests.where(program_id: @set_a_service.id).last
    @last_shock_service = @vehicle.requests.where(program_id: @set_shock_service.id).last
    @last_air_filter_service = @vehicle.requests.where(program_id: @set_air_filter_service.id).last
    @checklists = @vehicle.checklists.all
  end

  def near_service_required
    @q = Vehicle.where(near_service: true).ransack(params[:q])
    @vehicle_results = @q.result.page
    respond_to do |format|
      format.html
      format.csv { send_data @vehicle_results.to_csv }
      format.xls
      format.pdf do
        render pdf: "Near Service Vehicles for #{Time.now.strftime('%D')}", layout: 'pdf.pdf.erb', title: "Near Service Vehicles for #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
      end
    end
  end

  def show
    @set_defects = Program.find_by(name: 'Defect')
    @set_new = Tracker.find_by(track: 'New')
    @request = Request.all

    unless @vehicle.last_a_service.nil?
      @vehicle.update(near_a_service_mileage: (@set_a_service.interval - (@vehicle.mileage - @vehicle.last_a_service)))
      x = @vehicle.near_a_service_mileage
      case
      when x <= 0
        @vehicle.update(needs_service: true, a_service: true)
      when x <= 100
        @vehicle.update(near_service: true)
      when x > 100
        @vehicle.update(needs_service: false, a_service: false, near_service: false)
      end
    end
    unless @vehicle.last_shock_service.nil?
      @vehicle.update(near_shock_service_mileage: (@set_shock_service.interval - (@vehicle.mileage - @vehicle.last_shock_service)))
      
      y = @vehicle.near_shock_service_mileage
      case 
      when y <= 0
        @vehicle.update(needs_service: true, shock_service: true)
      when y <= 200
        @vehicle.update(near_service: true)
      when y > 200
        @vehicle.update(needs_service: false, shock_service: false, near_service: false)
      end
    end
    unless @vehicle.last_air_filter_service.nil?
      @vehicle.update(near_air_filter_service_mileage: (@set_air_filter_service.interval - (@vehicle.mileage - @vehicle.last_air_filter_service)))
      
      z = @vehicle.near_air_filter_service_mileage
      case
      when z <= 0
        @vehicle.update(needs_service: true, air_filter_service: true)
      when z <= 50
        @vehicle.update(near_service: true)
      when z > 50
        @vehicle.update(needs_service: false, air_filter_service: false, near_service: false)
      end
    end
    respond_to do |format|
      format.html
      format.csv { send_data @vehicle.to_csv }
      format.xls
      format.pdf do
        render pdf: "Vehicle #{@vehicle.car_id}", layout: 'pdf.pdf.erb', title: "Vehicle #{@vehicle.car_id} on #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
      end
    end
  end

  def in_service
    @in_service = Vehicle.where(vehicle_status: 'In-Service')
    @q = Vehicle.where(vehicle_status: 'In-Service').ransack(params[:q])
    @vehicle_results = @q.result
    respond_to do |format|
      format.html
      format.csv { send_data @vehicle_results.to_csv }
      format.xls
      format.pdf do
        render pdf: "In Service Vehicles for #{Time.now.strftime('%D')}", layout: 'pdf.pdf.erb', title: "In Service Vehicles for #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
      end
    end
  end

  def out_of_service
    @out_of_service = Vehicle.where(vehicle_status: 'Out-of-Service')
    @q = Vehicle.where(vehicle_status: 'Out-of-Service').ransack(params[:q])
    @vehicle_results = @q.result
    respond_to do |format|
      format.html
      format.csv { send_data @vehicle_results.to_csv }
      format.xls
      format.pdf do
        render pdf: "Out of Service Vehicles for #{Time.now.strftime('%D')}", layout: 'pdf.pdf.erb', title: "Out of Service Vehicles for #{Time.now.strftime('%D')}" # Excluding ".pdf" extension.
      end
    end
  end

  def all_vehicles
    @q = Vehicle.ransack(params[:q])
    @vehicle_results = @q.result.page(params[:page])
  end

  def needs_service
    @q = Vehicle.where(needs_service: true).ransack(params[:q])
    @vehicle_results = @q.result
    respond_to do |format|
      format.html
      format.csv { send_data @vehicle_results.to_csv }
      format.xls
      format.pdf do
        render pdf: "Vehicles That Need Service for #{Time.now.strftime('%D')}", layout: 'pdf.pdf.erb' # Excluding ".pdf" extension.
      end
    end
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
    @location = Location.all
  end
  
  def to_pdf(vehicle)
    
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully created.' }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        if @vehicle.vehicle_status == 'In-Service'
          @vehicle.update(repair_needed: false, defect: false)
        end
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to all_vehicles_vehicles_url, notice: 'Vehicle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def set_all_vehicles
    @vehicles = Vehicle.all
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

  def set_tracker
    @tracks = Tracker.all
  end

  def set_new
    @set_new = Tracker.find_by(track: 'New')
  end

  def set_progress
    @set_progress = Tracker.find_by(track: 'In-Progress')
  end

  def set_completed
    @set_completed = Tracker.find_by(track: 'Completed')
  end

  def set_overdue
    @set_overdue = Tracker.find_by(track: 'Overdue')
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def vehicle_params
    params.require(:vehicle).permit(:car_id, :manufacturer, :vehicle_status, :use_near_service, :vin_number, :vehicle_category_id, :registration_date, :plate_number, :notes, :repair_needed, :needs_service, :high_use, :mileage, :prep, :sale_date, :purchaser, :near_service, :a_service, :last_a_service, :last_shock_service, :last_air_filter_service, :use_a, :use_b, :dont_use_shock_service, :dont_use_a_service, :dont_use_air_filter_service, :veh_category, :location, :shock_service, :times_used, :est_mileage, :air_filter_service, :location_id, :event_id, vehicle_ids: [])
  end
end
