class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: [:a_service_calculation, :index, :mileage_calculation, :shock_service_calculation, :air_filter_calculation, :show, :needs_service, :near_service_required, :all_vehicles]
  before_action :set_tracker, :set_new, :set_progress, :set_completed, :set_overdue, only: [:a_service_calculation, :index, :mileage_calculation, :shock_service_calculation, :air_filter_calculation, :show, :needs_service, :near_service_required, :all_vehicles]
  before_action :set_all_vehicles, :in_service, :out_of_service, only: [:a_service_calculation, :index, :mileage_calculation, :shock_service_calculation, :air_filter_calculation, :show, :needs_service, :near_service_required, :all_vehicles]
  before_action :mileage_calculation, only: [:near_service_required, :needs_service]
  
  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.all
    @request = Request.all
    @first_vehicles = Vehicle.where(id: 1..20)
    @second_vehicles = Vehicle.where(id: 21..40)
    @third_vehicles = Vehicle.where(id: 41..60)
    @fourth_vehicles = Vehicle.where(id: 61..75)
    @fifth_vehicles = Vehicle.where(id: 76..96)
   
  end
  
  def import
    Vehicle.import(params[:file])
    redirect_to root_url, notice: "Activity Data Imported!"
  end

  def mileage_calculation
    @vehicles = Vehicle.all
    @vehicles.all.each do |vehicle|
    if vehicle.last_a_service != nil
      @a_service = (@set_a_service.interval - (vehicle.mileage - vehicle.last_a_service))
      if @a_service < 0
        vehicle.update(needs_service: true, a_service: true)
      elsif @a_service <= 100
        vehicle.update(near_service: true)
      else
        vehicle.update(needs_service: false, a_service: false, near_service: false)
      end
    end
        if vehicle.last_shock_service != nil
          @shock_service = (@set_shock_service.interval - (vehicle.mileage - vehicle.last_shock_service))
          if @shock_service < 0
            vehicle.update(needs_service: true, shock_service: true)
          elsif @shock_service <= 200
            vehicle.update(near_service: true)
          else
            vehicle.update(needs_service: false, shock_service: false, near_service: false)
          end
        end
      #when @vehicle.programs.exists?(7) == true
       if vehicle.last_air_filter_service != nil 
         @air_filter_service = (@set_air_filter_service.interval - (vehicle.mileage - vehicle.last_air_filter_service))
         if @air_filter_service < 0
           vehicle.update(needs_service: true, air_filter_service: true)
         elsif @air_filter_service <= 50
           vehicle.update(near_service: true)
         else
           vehicle.update(needs_service: false, air_filter_service: false, near_service: false)
         end
       end
     end 
  end
  
  def near_service_required
  
  @q = Vehicle.where(near_service: true).ransack(params[:q])
  @vehicle_results = @q.result.page(params[:page])
  respond_to do |format|
      format.html
      format.csv { send_data @vehicle_results.to_csv }
      format.xls
      format.pdf do
        render pdf: "Near Service Vehicles for #{Time.now.strftime('%D')}", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
      end
    end
    
  end
  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
    @set_defects = Program.find_by(name: "Defect")
    @set_new = Tracker.find_by(track: "New")
    @request = Request.all
    respond_to do |format|
        format.html
        format.csv { send_data @vehicle.to_csv }
        format.xls
        format.pdf do
          render pdf: "Vehicle #{@vehicle.car_id}", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
        end
      end
      
      if @vehicle.last_a_service != nil
        @a_service = (@set_a_service.interval - (@vehicle.mileage - @vehicle.last_a_service))
        if @a_service < 0
          @vehicle.update(needs_service: true, a_service: true)
        elsif @a_service <= 100
          @vehicle.update(near_service: true)
        else
          @vehicle.update(needs_service: false, a_service: false, near_service: false)
        end
      end
          if @vehicle.last_shock_service != nil
            @shock_service = (@set_shock_service.interval - (@vehicle.mileage - @vehicle.last_shock_service))
            if @shock_service < 0
              @vehicle.update(needs_service: true, shock_service: true)
            elsif @shock_service <= 200
              @vehicle.update(near_service: true)
            else
              @vehicle.update(needs_service: false, shock_service: false, near_service: false)
            end
          end
        #when @vehicle.programs.exists?(7) == true
         if @vehicle.last_air_filter_service != nil 
           @air_filter_service = (@set_air_filter_service.interval - (@vehicle.mileage - @vehicle.last_air_filter_service))
           if @air_filter_service < 0
             @vehicle.update(needs_service: true, air_filter_service: true)
           elsif @air_filter_service <= 50
             @vehicle.update(near_service: true)
           else
             @vehicle.update(needs_service: false, air_filter_service: false, near_service: false)
           end
         end
     
      
  end
  
  def in_service
    @in_service = Vehicle.where(vehicle_status: "In-Service")
    @q = Vehicle.where(vehicle_status: "In-Service").ransack(params[:q])
    @vehicle_results = @q.result.page(params[:page])
    respond_to do |format|
        format.html
        format.csv { send_data @vehicle_results.to_csv }
        format.xls
        format.pdf do
          render pdf: "In Service Vehicles for #{Time.now.strftime('%D')}", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
        end
      end
      
  end
  
  def out_of_service
    @out_of_service = Vehicle.where(vehicle_status: "Out-of-Service")
    @q = Vehicle.where(vehicle_status: "Out-of-Service").ransack(params[:q])
    @vehicle_results = @q.result
    respond_to do |format|
        format.html
        format.csv { send_data @vehicle_results.to_csv }
        format.xls 
        format.pdf do
          render pdf: "Out of Service Vehicles for #{Time.now.strftime('%D')}", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
        end
      end
      
  end
  
  def all_vehicles
    @q = Vehicle.ransack(params[:q])
    @vehicle_results = @q.result.page(params[:page])
    respond_to do |format|
        format.html
        format.csv { send_data @vehicle_results.to_csv }
        format.xls 
        format.pdf do
          render pdf: "Vehicles for #{Time.now.strftime('%D')}", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
        end
      end
  end
  
  def needs_service
   
   @q = Vehicle.where(needs_service: true).ransack(params[:q])
   @vehicle_results = @q.result.page(params[:page])
   respond_to do |format|
       format.html
       format.csv { send_data @vehicle_results.to_csv }
       format.xls 
       format.pdf do
         render pdf: "Vehicles That Need Service for #{Time.now.strftime('%D')}", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
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
        if @vehicle.vehicle_status == "In-Service"
          @vehicle.update(repair_needed: false, defect: false)
        end
        format.html { redirect_to @vehicle, notice: 'Vehicle was successfully updated.' }
        format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
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


    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit(:car_id, :manufacturer, :vehicle_status, :use_near_service, :vin_number, :vehicle_category_id, :registration_date, :plate_number, :repair_needed, :needs_service, :mileage, :near_service, :a_service, :last_a_service, :last_shock_service, :last_air_filter_service, :use_a, :use_b, :dont_use_shock_service, :dont_use_a_service, :dont_use_air_filter_service, :veh_category, :location, :shock_service, :times_used, :est_mileage, :air_filter_service, :location_id, :event_id, vehicle_ids: [])
    end
end
