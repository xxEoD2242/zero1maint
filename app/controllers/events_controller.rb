class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_location, only: [:index, :show, :edit, :new, :create, :update]
  before_action :set_vehicles, only: [:index, :show, :edit, :new, :create, :update]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: [:vehicle_rotation]
  before_action :set_tracker, :set_new, :set_progress, :set_completed, :set_overdue, only: [:vehicle_rotation]
  
 
  
  # GET /events
  # GET /events.json
  def index
    @events = Event.all.order(:created_at)
    @q = Event.order(:created_at).ransack(params[:q])
    @event_results = @q.result.includes(:vehicles).page(params[:page])
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @checklists = Checklist.where(event_id: @event.id)
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "Event #\: #{@event.id} ", :layout => 'pdf.pdf.erb', :title => "Event #\: #{@event.id}"  # Excluding ".pdf" extension.
         end
       end
  end
  
  def json_data
  render json:  @json_data = HTTParty.get('https://zero-1-maint.herokuapp.com/fare_harbor', :headers =>{'Content-Type' => 'application/json'} )
  end
  
  def dashboard
    @events = Event.all
    @scheduled_events = Event.where(status: 'Scheduled')
    @completed_events = Event.where(status: 'Completed')
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @events_by_date = Event.group('events.id').group_by(&:date)
    
  end
  
  def completed_events
    @q = Event.where(status: 'Completed').order(:created_at).ransack(params[:q])
    @event_results = @q.result.includes(:vehicles).page(params[:page])
  end
  
  def scheduled_events
    
    @q = Event.where(status: 'Scheduled').order(:created_at).ransack(params[:q])
    @event_results = @q.result.includes(:vehicles).page(params[:page])
  end

  # GET /events/new
  def new
    @event = Event.new
    @vehicles = Vehicle.all
    @vehicle_categories = VehicleCategory.all
  end

  # GET /events/1/edit
  def edit
    @vehicles = Vehicle.all
    @vehicle_categories = VehicleCategory.all
  end
  
  def vehicle_rotation
    @events = Event.where('date <= ?', Time.now + 7.days)
    @events_2 = @events.where('date >= ?', Time.now)
    @scheduled_events = @events_2.where(status: "Scheduled")
    event_mileage = []
    if @scheduled_events != []
    @scheduled_events.each do |event|
      event_mileage <<event.est_mileage
    end
    @total_miles = event_mileage.sum
    end
    
    
    if @total_miles != nil
      @vehicles = Vehicle.all
      @requests = Request.all
      @vehicles.all.each do |vehicle|
      if vehicle.last_a_service != nil
        @a_service = (@set_a_service.interval - ((vehicle.mileage + @total_miles) - vehicle.last_a_service))
        if @a_service < 0
          vehicle.update(use: false, dont_use_a_service: true)
        elsif @a_service <= 100
          vehicle.update(use_near_service: true)
        else
          vehicle.update(use: true, dont_use_a_service: false, use_near_service: false)
        end
      end
          if vehicle.last_shock_service != nil
            @shock_service = (@set_shock_service.interval - ((vehicle.mileage + @total_miles) - vehicle.last_shock_service))
            if @shock_service < 0
              vehicle.update(use: false, dont_use_shock_service: true)
            elsif @shock_service <= 200
              vehicle.update(use_near_service: true)
            else
              vehicle.update(use: true, dont_use_shock_service: false, use_near_service: false)
            end
          end
        #when @vehicle.programs.exists?(7) == true
         if vehicle.last_air_filter_service != nil
           @air_filter_service = (@set_air_filter_service.interval - ((vehicle.mileage + @total_miles) - vehicle.last_air_filter_service))
           if @air_filter_service < 0
             vehicle.update(dont_use_air_filter_service: true)
           elsif @air_filter_service <= 50
             vehicle.update(use_near_service: true)
           else
             vehicle.update(use: true, dont_use_air_filter_service: false, use_near_service: false)
           end
         end
       end 
     end
     
     Vehicle.all.each do |vehicle|
       if vehicle.events.where('date > ?', Time.now - 1.month).count >= 5
         vehicle.update(use: false)
       end
       if vehicle.vehicle_status == "Out-of-Service"
         vehicle.update(use: false)
       end
     end
     
     
     
     @q = Vehicle.all.ransack(params[:q])
     @vehicle_results = @q.result
     
     
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
        if @event.status == "Completed"
        @event.vehicles.each do |vehicle|
          vehicle.update(mileage: (vehicle.mileage + event_mileage))
        end
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

    def set_vehicle_category
      @vehicle_category = VehicleCategory.all
    end
    
    def set_location
      @location = Location.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:date, :event_mileage, :location_id, :event_time, :duration, :event_type, :est_mileage, :class_type, :number, :status, vehicle_ids: [])
    end
    
    
end
