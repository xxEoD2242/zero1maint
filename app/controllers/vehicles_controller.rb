# frozen_string_literal: true

class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[show edit update destroy]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: %i[a_service_calculation index mileage_calculation shock_service_calculation air_filter_calculation show needs_service near_service_required all_vehicles vehicle_mileage in_service out_of_service]
  before_action :in_service, :out_of_service, only: %i[a_service_calculation index shock_service_calculation air_filter_calculation all_vehicles]
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
    to_pdf @vehicle_results, "Near Service Vehicles for #{Date.current.strftime('%D')}"
  end

  def show
    @vehicle.set_thresholds
    @set_defects = Program.find_by(name: 'Defect')
    @defects = @vehicle.defects.order(created_at: :desc)
    @request = Request.all

    a_service_check @vehicle
    shock_service_check @vehicle 
    air_filter_service_check @vehicle
    need_service_check @vehicle
    near_service_check @vehicle
    to_pdf @vehicle, "Vehicle #{@vehicle.car_id}"
  end

  def in_service
    @in_service = Vehicle.where(vehicle_status: 'In-Service')
    @q = Vehicle.where(vehicle_status: 'In-Service').ransack(params[:q])
    @vehicle_results = @q.result
    to_pdf @vehicle_results, "In Service Vehicles for #{Date.current.strftime('%D')}"
  end

  def out_of_service
    @out_of_service = Vehicle.where(vehicle_status: 'Out-of-Service')
    @q = Vehicle.where(vehicle_status: 'Out-of-Service').ransack(params[:q])
    @vehicle_results = @q.result
    to_pdf @vehicle_results, "Out of Service Vehicles for #{Date.current.strftime('%D')}"
  end

  def all_vehicles
    @q = Vehicle.ransack(params[:q])
    @vehicle_results = @q.result.page(params[:page])
  end

  def needs_service
    @needs_service_vehicles = Vehicle.where(needs_service: true).all
    to_pdf @needs_service_vehicles, "Vehicles That Need Service for #{Date.current.strftime('%D')}"
  end

  def new
    @vehicle = Vehicle.new
  end

  def edit
    @location = Location.all
  end

  def to_pdf(vehicles, file_name)
    respond_to do |format|
      format.html
      format.csv { send_data vehicles.to_csv }
      format.xls
      format.pdf do
        render pdf: file_name, layout: 'pdf.pdf.erb', title: file_name
      end
    end
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

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

  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to all_vehicles_vehicles_url, notice: 'Vehicle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

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

  def vehicle_params
    params.require(:vehicle).permit(:car_id, :manufacturer, :vehicle_status, :use_near_service,
                                    :vin_number, :vehicle_category_id, :registration_date, :plate_number,
                                    :notes, :repair_needed, :needs_service, :high_use, :mileage, :prep,
                                    :sale_date, :purchaser, :near_service, :a_service, :last_a_service,
                                    :last_shock_service, :last_air_filter_service, :use_a, :use_b,
                                    :dont_use_shock_service, :dont_use_a_service, :dont_use_air_filter_service,
                                    :veh_category, :location, :shock_service, :times_used, :est_mileage,
                                    :a_service_interval, :shock_service_interval, :air_filter_service_interval,
                                    :air_filter_service, :location_id, :event_id, vehicle_ids: [])
  end
end
