class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  before_action :set_vehicle_category, only: [:edit, :update, :destroy, :new, :show]
  before_action :set_location, only: [:index, :show, :new, :edit]
 
  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.all.page(params[:page])
    @request = Request.all
    
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
    @request = Request.all
  end
  
  def in_service
    @in_service = Vehicle.where(vehicle_status: "In-Service").page(params[:page])
  end
  
  def out_of_service
    @out_of_service = Vehicle.where(vehicle_status: "Out-of-Service").page(params[:page])
  end
  
  def all_vehicles
    @vehicles = Vehicle.all.page(params[:page])
  end
  
  def needs_service
    
  Vehicle.where(vehicle_status: "In-Service").each do |car|
  Program.all.each do |program|
  if car.programs.where(name: program.name) != []
    if (car.programs.where(name: program.name).last.interval) - (car.mileage - car.programs.where(name: program.name).last.requests.last.request_mileage) < 0
      car.update(needs_service: true)
    end  
    end
  end
 end

     
      
      if @vehicles != []
      
      @a_service = Program.find(8).vehicles.where(needs_service: true)
      @air_filter_service = Program.find(7).vehicles.where(needs_service: true)
      @shock_service = Program.find(9).vehicles.where(needs_service: true)
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
      format.html { redirect_to vehicles_url, notice: 'Vehicle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def set_vehicle_category
      @vehicle_category = VehicleCategory.all
    end
    
    def set_location
      @location = Location.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit(:car_id, :vehicle_category_id, :manufacturer, :vehicle_status, :vin_number, :registration_date, :plate_number, :needs_service, :mileage, :location_id, :event_id, vehicle_ids: [])
    end
end
