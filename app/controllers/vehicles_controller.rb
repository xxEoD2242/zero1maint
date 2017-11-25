class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  before_action :set_vehicle_category, only: [:edit, :update, :destroy, :new, :show, :index]
  before_action :set_location, only: [:index, :show, :new, :edit]
  before_action :set_all_vehicles, :in_service, :out_of_service, only: [:a_service_calculation, :index, :mileage_calculation, :shock_service_calculation, :air_filter_calculation, :show, :needs_service]
  before_action :set_all_vehicles, :a_service_calculation, :shock_service_calculation, :air_filter_calculation, only: [:show, :near_service_required]
  before_action :mileage_calculation, only: [:dashboard, :near_service_required, :needs_service]
 
  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.all
    @request = Request.all
    @q = Vehicle.ransack(params[:q])
    @cars = @q.result
    respond_to do |format|
        format.html
        format.csv { send_data @cars.to_csv }
        format.xls 
      end
  end
  
  def import
    Vehicle.import(params[:file])
    redirect_to root_url, notice: "Activity Data Imported!"
  end

  def mileage_calculation
    @vehicles = Vehicle.all
    @vehicles.all.each do |vehicle|
    if vehicle.requests.where(program_id: 1, tracker_id: 3) != []
      @a_service = (Program.find(1).interval - (vehicle.mileage - vehicle.requests.where(program_id: 1, tracker_id: 3).last.request_mileage))
      if @a_service < 0
        vehicle.update(needs_service: true, a_service: true)
      elsif @a_service <= 100
        vehicle.update(near_service: true)
      else
        vehicle.update(needs_service: false, a_service: false, near_service: false)
      end
    end
        if vehicle.requests.where(program_id: 2, tracker_id: 3) != []
          @shock_service = (Program.find(2).interval - (vehicle.mileage - vehicle.requests.where(program_id: 2, tracker_id: 3).last.request_mileage))
          if @shock_service < 0
            vehicle.update(needs_service: true, shock_service: true)
          elsif @shock_service <= 200
            vehicle.update(near_service: true)
          else
            vehicle.update(needs_service: false, shock_service: false, near_service: false)
          end
        end
      #when @vehicle.programs.exists?(7) == true
       if vehicle.requests.where(program_id: 3, tracker_id: 3) != [] 
         @air_filter_service = (Program.find(3).interval - (vehicle.mileage - vehicle.requests.where(program_id: 3, tracker_id: 3).last.request_mileage))
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
    end
  end
  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
    @request = Request.all
    if @vehicle.requests.where(program_id: 1) != []
      if @a_service < 0
        @vehicle.update(needs_service: true)
      else
        @vehicle.update(needs_service: false)
      end
    end
        if @vehicle.requests.where(program_id: 2) != []
          if @shock_service < 0
            @vehicle.update(needs_service: true)
          else
            @vhecile.update(needs_service: false)
          end
        end
       if @vehicle.requests.where(program_id: 3) != [] 
         if @air_filter_service < 0
           @vehicle.update(needs_service: true)
         else
           @vehicle.update(needs_service: false)
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
      end
  end
  
  def out_of_service
    @out_of_service = Vehicle.where(vehicle_status: "Out-of-Service")
    @q = Vehicle.where(vehicle_status: "Out-of-Service").ransack(params[:q])
    @vehicle_results = @q.result.page(params[:page])
    respond_to do |format|
        format.html
        format.csv { send_data @vehicle_results.to_csv }
        format.xls 
      end
  end
  
  def all_vehicles
    @vehicles = Vehicle.all.page(params[:page])
    @q = Vehicle.ransack(params[:q])
    @vehicle_results = @q.result.page(params[:page])
    respond_to do |format|
        format.html
        format.csv { send_data @vehicle_results.to_csv }
        format.xls
      end
  end
  
  def needs_service
   
   @q = Vehicle.where(needs_service: true).ransack(params[:q])
   @vehicle_results = @q.result.page(params[:page])
   respond_to do |format|
       format.html
       format.csv { send_data @vehicle_results.to_csv }
       format.xls 
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
  
  def a_service_calculation
    @vehicles.all.each do |vehicle|
      if vehicle.requests.where(program_id: 1, tracker_id: 3) != []
    @a_service = (Program.find(1).interval - (vehicle.mileage - vehicle.requests.where(program_id: 1, tracker_id: 3).last.request_mileage))
  end
end
  end
  
  def shock_service_calculation
    @vehicles.all.each do |vehicle|
      if vehicle.requests.where(program_id: 2, tracker_id: 3) != []
    @shock_service = (Program.find(2).interval - (vehicle.mileage - vehicle.requests.where(program_id: 2, tracker_id: 3).last.request_mileage))
  end
end
  end
  
  def air_filter_calculation
    
    @vehicles.all.each do |vehicle|
      if vehicle.requests.where(program_id: 3, tracker_id: 3) != []
     @air_filter_service = (Program.find(3).interval - (vehicle.mileage - vehicle.requests.where(program_id: 3, tracker_id: 3).last.request_mileage))
   end
 end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
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


    def set_vehicle_category
      @vehicle_category = VehicleCategory.all
    end
    
    def set_location
      @location = Location.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit(:car_id, :manufacturer, :vehicle_status, :vin_number, :vehicle_category_id, :registration_date, :plate_number, :repair_needed, :needs_service, :mileage, :near_service, :a_service, :shock_service, :air_filter_service, :location_id, :event_id, vehicle_ids: [])
    end
end
