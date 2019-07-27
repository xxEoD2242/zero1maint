# frozen_string_literal: true

class VehiclesController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_vehicle, only: %i[show edit update destroy defects]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, 
                :set_tour_car_prep, 
                only: %i[a_service_calculation mileage_calculation shock_service_calculation
                         air_filter_calculation show needs_service near_service_required all_vehicles
                         vehicle_mileage in_service out_of_service]
  before_action :mileage_calculation, only: %i[needs_service near_service_required]
  include Vehicle_Rotation

  def index
    @vehicles = Vehicle.all.size
    @in_service = Vehicle.in_service?.size
    @out_of_service = Vehicle.out_of_service?.size
    @defects_outstanding = Vehicle.where(defect: true).size
    @sold = Vehicle.where(vehicle_status: 'Sold').size
    @needs_service = Vehicle.where(needs_service: true).size
    @near_service = Vehicle.where(near_service: true).size
  end

  def sold_vehicles
    @q = Vehicle.where(vehicle_status: 'Sold').ransack(params[:q])
    @search_results = @q.result.page(params[:page])
  end

  def defects
    @vehicle = Vehicle.find(params[:id])
    @q = @vehicle.defects.ransack(params[:q])
    @defects = @q.result.order(fixed: :asc).page(params[:page])
  end

  def import
    Vehicle.import(params[:file])
    redirect_to root_url, notice: 'Vehicle Data Imported!'
  end

  def vehicle_mileage
    @vehicle = Vehicle.find(params[:id])
    @events = @vehicle.events.where('date >= ?', Date.current - 1.year).page(params[:page])
    @events_month = @vehicle.events.where('date >= ?', Date.current - 1.month)
    @events_for_calculation = @vehicle.events.where('date >= ?', (Date.current - 1.year)).all

    # Calculate the year-to-date and month-to-date mileage
    @ytd_mileage = 0
    @mtd_mileage = 0
    @events_for_calculation.each do |event|
      @ytd_mileage += event.event_mileage
    end
    @events_month.all.each do |event|
      @mtd_mileage += event.event_mileage
    end

    @times_used = @events_for_calculation.size
    @times_used_month = @events_month.size
    @last_a_service = @vehicle.requests.is_an_a_service.last
    @last_shock_service = @vehicle.requests.is_a_shock_service.last
    @last_air_filter_service = @vehicle.requests.is_a_air_filter_service.last
    if @vehicle.tour_car?
      @last_tour_car_prep = @vehicle.requests.is_a_tour_car_prep.last
    end
    @checklists = @vehicle.checklists.all
  end

  def near_service_required
    @q = Vehicle.where(near_service: true).ransack(params[:q])
    @search_results = @q.result.page(params[:page])
    to_pdf @search_results, "Near Service Vehicles for #{Date.current.strftime('%D')}"
  end

  def show
    if @vehicle.requests.where(status: "Overdue").exists?
      flash[:alert] = "This vehicle has overdue work orders!"
    end
    @work_orders = Request.where(vehicle_id: @vehicle.id).reorder(completed_date: :desc)
    @vehicle.set_thresholds
    services_check @vehicle
    check_overdue @vehicle
    @set_defects = Program.find_by(name: 'Defect')
    @defects = @vehicle.defects.order(created_at: :desc).are_not_fixed?
    @request = Request.where(vehicle_id: @vehicle.id)
    to_pdf @vehicle, "Vehicle #{@vehicle.car_id}"
  end

  # This function checks to see if the vehicle has overdue work orders that would be needed
  # to be completed before performing actions in the system.
  # FUTURE FEATURE: Have it so that when there is an overdue work order that is given to them,
  # there is both a notification and the system loads to that work order.
  def check_overdue(vehicle)
    if vehicle.requests.where(status: "Overdue").exists?
      vehicle.update(work_orders_overdue: true)
    else
      vehicle.update(work_orders_overdue: false)
    end
  end

  def services_check(vehicle)
    a_service_check vehicle
    shock_service_check vehicle 
    air_filter_service_check vehicle
    if vehicle.veh_category == 'Tour Car'
      tour_car_prep_check vehicle
    end
    defects_check vehicle
    need_service_check vehicle
    near_service_check vehicle
  end

  def in_service
    @q = Vehicle.where(vehicle_status: 'In-Service').ransack(params[:q])
    @search_results = @q.result.page(params[:page])
    to_pdf @search_results, "In Service Vehicles for #{Date.current.strftime('%D')}"
  end

  def out_of_service
    @q = Vehicle.where(vehicle_status: 'Out-of-Service').ransack(params[:q])
    @search_results = @q.result.page(params[:page])
    to_pdf @search_results, "Out of Service Vehicles for #{Date.current.strftime('%D')}"
  end

  def all_vehicles
    @q = Vehicle.ransack(params[:q])
    @search_results = @q.result.page(params[:page])
  end

  def needs_service
    @q = Vehicle.where(needs_service: true).ransack(params[:q])
    @search_results = @q.result.page(params[:page])
    to_pdf @search_results, "Vehicles That Need Service for #{Date.current.strftime('%D')}"
  end

  def defects_outstanding
    @q = Vehicle.where(defect: true).ransack(params[:q])
    @vehicles = @q.result.page(params[:page])
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
  
  def set_tour_car_prep
    @set_tour_car_prep = Program.find_by(name: 'Tour Car Prep')
  end

  def vehicle_params
    params.require(:vehicle).permit(:car_id, :manufacturer, :vehicle_status, :use_near_service,
                                    :vin_number, :vehicle_category_id, :registration_date, :plate_number,
                                    :notes, :repair_needed, :needs_service, :high_use, :mileage, :prep,
                                    :sale_date, :purchaser, :near_service, :a_service, :last_a_service,
                                    :last_shock_service, :last_air_filter_service, :use_a, :use_b,
                                    :dont_use_shock_service, :dont_use_a_service, :dont_use_air_filter_service,
                                    :dont_use_near_a_service, :dont_use_near_shock_service, :dont_use_near_air_filter_service,
                                    :dont_use_near_tour_car_prep, :dont_use_near_a_service_mileage, :dont_use_near_shock_service_mileage,
                                    :dont_use_near_air_filter_service_mileage, :dont_use_near_tour_car_prep_mileage,
                                    :veh_category, :location, :shock_service, :times_used, :est_mileage,
                                    :a_service_interval, :shock_service_interval, :air_filter_service_interval,
                                    :air_filter_service, :tour_car_prep, :near_tour_car_prep, :near_tour_car_prep_mileage,
                                    :last_tour_car_prep_mileage, :work_orders_overdue, :times_used_year, :location_id, :event_id, vehicle_ids: [])
  end
end
