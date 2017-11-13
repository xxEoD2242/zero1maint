class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_location, only: [:index, :show, :edit, :new]
  before_action :set_vehicles, only: [:index, :show, :edit, :new]
  
 
  
  # GET /events
  # GET /events.json
  def index
    @events = Event.all.page(params[:page]).order(:created_at)
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end
  
  

  # GET /events/new
  def new
    @event = Event.new
    @vehicles = Vehicle.all
    @vehicle_categories = VehicleCategory.all
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        event_mileage = @event.event_mileage
        @event.vehicles.each do |vehicle|
          vehicle.update(mileage: (vehicle.mileage + event_mileage))
        end
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end
    
    def set_location
      @location = Location.all
    end
    
    def set_vehicles
      @vehicles = Vehicle.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:date, :event_mileage, :location_id, :duration, :event_type, :class_type, :status, vehicle_ids: [])
    end
end