class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_location, only: [:index, :show, :edit, :new, :create, :update]
  before_action :set_vehicles, only: [:index, :show, :edit, :new, :create, :update]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: [:vehicle_rotation, :new, :edit]
  before_action :set_tracker, :set_new, :set_progress, :set_completed, :set_overdue, only: [:vehicle_rotation, :new, :edit]
  before_action :vehicle_use_count, only: [:dashboard, :show, :vehicle_rotation]
  before_action :vehicle_rotation, only: [:edit]
  
  
 
  
  # GET /events
  # GET /events.json
  def index
    
    @q = Event.all.ransack(params[:q])
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
    @events = Event.where('date >= ?', Time.now - 7.days)
    @display_events = @events.where('date <= ?', Time.now + 14.days)
    @scheduled_events = Event.where(status: 'Scheduled')
    @completed_events = Event.where(status: 'Completed')
    @assigned_events = Event.where(status: "Vehicles Assigned")
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @events_by_date = Event.group('events.id').group_by(&:date)
    
  end
  
  def completed_events
    @q = Event.where(status: 'Completed').order(:created_at).ransack(params[:q])
    @event_results = @q.result.includes(:vehicles).page(params[:page])
  end
  
  def vehicles_assigned
    @q = Event.where(status: 'Vehicles Assigned').order(:created_at).ransack(params[:q])
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
  
  def vehicle_use_count
    @eve = Event.where('date >= ?', Time.now - 1.month)
    @events = @eve.where('date <= ?', Time.now)
    Vehicle.all.update(times_used: 0)
    @events.each do |event|
    if event.vehicles.exists?
      event.vehicles.each do |vehicle|
        
        vehicle.update(times_used: (vehicle.times_used + 1))
      end
  end
end

end
  
  def auto_select_vehicles
    @event = Event.find(params[:id])
    @use_a = Vehicle.where(use_a: true, use_b: false)
    @use_b = Vehicle.where(use_b: true, use_a: false)
    @people = @event.customers
    @shares = @event.shares
    @event_vehicles = []
    
    if @event.event_type == "RZR"
    if @people != nil
      if @shares != nil
        @numb_vehicles = (@people - (@shares * 2)) + @shares
      else
      @numb_vehicles = @people
    end
    end
    if @use_a.all.count >= @numb_vehicles
    @use_a.where(veh_category: "RZR").order(times_used: :asc).limit(@numb_vehicles).each do |vehicle|
      @event_vehicles << vehicle.id
    end
    elsif @use_a.all.count < @numb_vehicles
      @a = (@numb_vehicles - @use_a.all.count)
      if @a != 0
        @b = (@numb_vehicles - @use_a.all.count - @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).all.count)
      end
      if @a != 0 && @b != 0
      @c = (@numb_vehicles - @use_a.all.count - @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).all.count -  @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count)
      end
      if @a != 0 && @b != 0 && @c != 0
      @d = (@numb_vehicles - @use_a.all.count - @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).all.count -  @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count - @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count)
      end
      if @a != 0 && @b != 0 && @c != 0 && @d !=0
      @f = (@numb_vehicles - @use_a.all.count - @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).all.count -  @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count - @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count - @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true).all.count)
      end
      
     
        @use_a.where(veh_category: "RZR").order(times_used: :asc).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      
      if @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).all.count > @a
      @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).order(times_used: :asc).limit(@a).each do |vehicle|
        @event_vehicles << vehicle.id        
      end
      
      elsif @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).all.count < @a &&  @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count > @b
        @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).order(times_used: :asc).limit(@a).each do |vehicle|
          @event_vehicles << vehicle.id
        end
      @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).order(times_used: :asc).limit(@b).each do |vehicle|
        @event_vehicles << vehicle.id
      end
      
      elsif  @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).all.count < @a && @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count < @b && @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count > @c
          
          @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).order(times_used: :asc).limit(@a).each do |vehicle|
            @event_vehicles << vehicle.id
          end
          @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).order(times_used: :asc).limit(@b.each do |vehicle|
            @event_vehicles << vehicle.id
          end
          @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).order(times_used: :asc).limit(@c).each do |vehicle|
            @event_vehicles << vehicle.id
          end
    
    elsif  @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).all.count < @a && @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count < @b && @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).all.count < @c && @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true).all.count > @d 
      
      @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true).order(times_used: :asc).limit(@a).each do |vehicle|
        @event_vehicles << vehicle.id
      end
      @use_b.where(veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).order(times_used: :asc).limit(@b).each do |vehicle|
        @event_vehicles << vehicle.id
      end
      @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true).order(times_used: :asc).limit(@c).each do |vehicle|
        @event_vehicles << vehicle.id
      end
      @use_b.where(veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true).order(times_used: :asc).limit(@d).each do |vehicle|
        @event_vehicles << vehicle.id
      end
    
    
  end
     
    end
     @event.update(vehicle_ids: @event_vehicles)
  end
  redirect_back(fallback_location: root_path)
end
  
  def vehicle_rotation
    @events = Event.where('date >= ?', Time.now)
    @events_2 = @events.where('date <= ?', Time.now + 7.days)
    @scheduled_events = @events_2.all.where(status: "Scheduled")
    event_mileage = 0
    new_event_mileage = 0
    @total_miles_added = 0
    if @scheduled_events != []
    @scheduled_events.each do |event|
      event_mileage += event.est_mileage
    end
    @total_miles = event_mileage
    end
    @vehicles_assigned = @events.all.where(status: "Vehicles Assigned")
  
    
    
      @vehicles = Vehicle.all
      @vehicles.update(use_a: true, use_b: false, use_near_service: false)
      if @total_miles == nil
        @vehicles.update(est_mileage: 0)
      else
        @vehicles.update(est_mileage: @total_miles)
      end
      if @vehicles_assigned != []
      @vehicles_assigned.each do |event|
        @total_miles_added += event.est_mileage
        event.vehicles.each do |vehicle|
          vehicle.update(est_mileage: (vehicle.est_mileage + event.est_mileage))
        end
      end
    end
      
      @vehicles.all.each do |vehicle|
      
      
      if vehicle.last_a_service != nil
          @a_service = (@set_a_service.interval - ((vehicle.mileage + vehicle.est_mileage) - vehicle.last_a_service))
        if @a_service < 0
          vehicle.update(use_b: true, use_a: false, dont_use_a_service: true)
        elsif @a_service <= 100
          vehicle.update(use_b: true, use_a: false, use_near_service: true)
        else
          vehicle.update(dont_use_a_service: false)
        end
      end
          if vehicle.last_shock_service != nil
            @shock_service = (@set_shock_service.interval - ((vehicle.mileage + vehicle.est_mileage) - vehicle.last_shock_service))
            if @shock_service < 0
              vehicle.update(use_b: true, use_a: false, dont_use_shock_service: true)
            elsif @shock_service <= 200
              vehicle.update(use_b: true, use_a: false, use_near_service: true)
            else
              vehicle.update(dont_use_shock_service: false)
            end
          end
        #when @vehicle.programs.exists?(7) == true
         if vehicle.last_air_filter_service != nil
             @air_filter_service = (@set_air_filter_service.interval - ((vehicle.mileage + vehicle.est_mileage) - vehicle.last_air_filter_service))
           if @air_filter_service < 0
             vehicle.update(use_b: true, use_a: false, dont_use_air_filter_service: true)
           elsif @air_filter_service <= 50
             vehicle.update(use_b: true, use_a: false, use_near_service: true)
           else
             vehicle.update(dont_use_air_filter_service: false)
           end
         end
   
         
       if vehicle.use_a == true && vehicle.times_used >= 5
         vehicle.update(use_a: false, use_b: true)
       elsif vehicle.use_b == true && vehicle.times_used >= 10
         vehicle.update(use_a: false, use_b: false)
       end
      
     
       if vehicle.vehicle_status == "Out-of-Service"
         vehicle.update(use_a: false, use_b: false)
       end
       end
     
    
     @q = Vehicle.all.ransack(params[:q])
     @vehicle_results = @q.result
     
     respond_to do |format|
          format.html
          format.xls
          format.pdf do
            render pdf: "Vehicle Rotation for #{Time.now.strftime('%D')}", :layout => 'pdf.pdf.erb', :title => "Vehicle Rotation for #{Time.now.strftime('%D')}"  # Excluding ".pdf" extension.
          end
        end
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

    
    
    def set_location
      @location = Location.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:date, :event_mileage, :location, :event_time, :duration, :event_type, :est_mileage, :customers, :shares, :class_type, :number, :status, vehicle_ids: [])
    end
    
    
end
