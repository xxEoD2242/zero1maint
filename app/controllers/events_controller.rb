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
  render json:  @json_data = HTTParty.get('https://zero-1-maint.herokuapp.com/:bookings', :headers =>{'Content-Type' => 'application/json'} )
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
  
  def next_month_calendar
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @next_month = @date + 1.month
    @events = Event.where('date <= ?', @next_month + 1.month)
    @display_events = @events.where('date >= ?', @next_month)
    @scheduled_events = Event.where(status: 'Scheduled')
    @completed_events = Event.where(status: 'Completed')
    @assigned_events = Event.where(status: "Vehicles Assigned")
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
    @use_a =                              Vehicle.where(use_a: true, use_b: false, veh_category: "RZR", use_near_service: false, location: @event.location)
    
    # Vehicles that have no future near service or needs service
    
    # actually Use A vehicles that need service
    @use_b_near_service =                 Vehicle.where(location: @event.location, use_b: false, use_a: true, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true)
    
    @use_b_air_filter_service_near =      Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false) 
    @use_b_a_service_near_1 =             Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: false)
    @use_b_shock_service_near_1 =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: true, dont_use_air_filter_service: false, use_near_service: false)
     
    @use_b_air_filter_service =           Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)
    
    @use_b_a_service_near_2 =             Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service =                    Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)
    
    @use_b_shock_service_near_2 =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_shock_service =                Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true)
   
    # Vehicles that Have near service but not needs service
    @use_b_near_service_nas =             Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true)
    
    @use_b_air_filter_service_near_nas =  Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false) 
    @use_b_a_service_near_1_nas =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: false)
    @use_b_shock_service_near_1_nas =     Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: true, dont_use_air_filter_service: false, use_near_service: false)
     
    @use_b_air_filter_service_nas =       Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)
    
    @use_b_a_service_near_2_nas =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_nas =                Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)
    
    @use_b_shock_service_near_2_nas =     Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_shock_service_nas =            Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true)
    
    # Vehicles that have needs service but not near service
    @use_b_near_service_nss =             Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true)
    
    @use_b_air_filter_service_near_nss =  Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false) 
    @use_b_a_service_near_1_nss =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: false)
    @use_b_shock_service_near_1_nss =     Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: true, dont_use_air_filter_service: false, use_near_service: false)
     
    @use_b_air_filter_service_nss =       Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)
    
    @use_b_a_service_near_2_nss =         Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_nss =                Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)
    
    @use_b_shock_service_near_2_nss =     Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_shock_service_nss =            Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: false, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true)
    
    # Vehicles that have needs service and near service
    @use_b_near_service_nass =            Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: true)
    
    @use_b_air_filter_service_near_nass = Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false) 
    @use_b_a_service_near_1_nass =        Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: false, use_near_service: false)
    @use_b_shock_service_near_1_nass =    Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: true, dont_use_air_filter_service: false, use_near_service: false)
     
    @use_b_air_filter_service_nass =      Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: "RZR", dont_use_a_service: false, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)
    
    @use_b_a_service_near_2_nass =        Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_a_service_nass =               Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: false, dont_use_air_filter_service: true, use_near_service: true)
    
    @use_b_shock_service_near_2_nass =    Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: true, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: false)
    @use_b_shock_service_nass =           Vehicle.where(location: @event.location, use_b: true, use_a: false, needs_service: false, near_service: true, veh_category: "RZR", dont_use_a_service: true, dont_use_shock_service: true, dont_use_air_filter_service: true, use_near_service: true)
    
    @people = @event.customers
    @shares = @event.shares
    @event_vehicles = []
    
    
    if @people != nil
      if @shares != nil
        @numb_vehicles = (@people - (@shares * 2)) + @shares
      else
      @numb_vehicles = @people
    end
    end
   
   
    @a = (@numb_vehicles - @use_a.all.count)
    @b = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count)
    @c = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count)
    @d = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count)
    @e = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count)
    @f = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count)
    @g = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count)
    @h = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count)
    @i = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count)
    @j = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count)
    @k = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count)
    @l = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count)
    @m = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count)
    @n = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count)
    @o = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count)
    @p = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count)
    @q = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count)
    @r = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count)
    @s = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count)
    @t = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count)
    @u = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count)
    @v = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count)
    @w = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count)
    @x = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count)
    @y = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count)
    @z = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count)
    @aa = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count)
    @ab = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count)
    @ac = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count)
    @ad = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count)
    @ae = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count)
    @af = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count)
    @ag = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count - @use_b_air_filter_service_nass.all.count)
    @ah = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count - @use_b_air_filter_service_nass.all.count - @use_b_a_service_near_2_nass.all.count)
    @ai = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count - @use_b_air_filter_service_nass.all.count - @use_b_a_service_near_2_nass.all.count - @use_b_a_service_nass.all.count)
    @aj = (@numb_vehicles - @use_a.all.count - @use_b_near_service.all.count - @use_b_air_filter_service_near.all.count - @use_b_a_service_near_1.all.count - @use_b_shock_service_near_1.all.count - @use_b_air_filter_service.all.count - @use_b_a_service_near_2.all.count - @use_b_a_service.all.count - @use_b_shock_service_near_2.all.count - @use_b_shock_service.all.count - @use_b_near_service_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_1_nas.all.count - @use_b_shock_service_near_1_nas.all.count - @use_b_air_filter_service_nas.all.count - @use_b_a_service_near_2_nas.all.count - @use_b_a_service_nas.all.count - @use_b_shock_service_near_2_nas.all.count - @use_b_shock_service_nas.all.count - @use_b_near_service_nss.all.count - @use_b_air_filter_service_near_nss.all.count - @use_b_a_service_near_1_nss.all.count - @use_b_shock_service_near_1_nss.all.count - @use_b_air_filter_service_nss.all.count - @use_b_a_service_near_2_nss.all.count - @use_b_a_service_nss.all.count - @use_b_shock_service_near_2_nss.all.count - @use_b_shock_service_nss.all.count - @use_b_near_service_nass.all.count - @use_b_air_filter_service_near_nass.all.count - @use_b_a_service_near_1_nass.all.count - @use_b_shock_service_near_1_nass.all.count - @use_b_air_filter_service_nass.all.count - @use_b_a_service_near_2_nass.all.count - @use_b_a_service_nass.all.count - @use_b_shock_service_near_2_nass.all.count)
   
  
    if @event.event_type == "RZR"
    
    if @use_a.all.count >= @numb_vehicles
    @use_a.order(times_used: :asc).limit(@numb_vehicles).each do |vehicle|
      @event_vehicles << vehicle.id
    end
   
   
   
    elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count >= @a
      
      @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
        @event_vehicles << vehicle.id
      end
    
    @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
      @event_vehicles << vehicle.id        
    end
    
    elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a &&  @use_b_air_filter_service_near.all.count >= @b
     
      
      @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
        @event_vehicles << vehicle.id
      end
    
    @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
      @event_vehicles << vehicle.id        
    end
    @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
      @event_vehicles << vehicle.id
    end
    
  elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count >= @c
    
    @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
      @event_vehicles << vehicle.id
    end
  
  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  
  elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count >= @d
   
    @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
      @event_vehicles << vehicle.id
    end
  
  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
      
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count >= @e
 
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

@use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
  @event_vehicles << vehicle.id        
end
@use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count >= @f
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count >= @g
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count >= @h
 
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count >= @i
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count >= @j
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count >= @k
 
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count >= @l
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count >= @m
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count >= @n
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count >= @o
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count >= @p
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count >= @q
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count >= @r
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count >= @s
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count >= @t
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count >= @u
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count >= @v
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count >= @w
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count >= @x
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count >= @y
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count >= @z
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count >= @ab
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count >= @ab
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count >= @ac
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count >= @ad
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
  @event_vehicles << vehicle.id
end

elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count >= @ae
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count >= @af
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count < @af && @use_b_a_service_near_2_nass.all.count >= @ag
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nass.order(times_used: :asc).limit(@ag).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count < @af && @use_b_a_service_near_2_nass.all.count < @ag && @use_b_a_service_nass.all.count >= @ah
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nass.order(times_used: :asc).limit(@ag).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nass.order(times_used: :asc).limit(@ah).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count < @af && @use_b_a_service_near_2_nass.all.count < @ag && @use_b_a_service_nass.all.count < @ah && @use_b_shock_service_near_2_nass.all.count >= @ai 
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nass.order(times_used: :asc).limit(@ag).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nass.order(times_used: :asc).limit(@ah).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nass.order(times_used: :asc).limit(@ai).each do |vehicle|
  @event_vehicles << vehicle.id
end
elsif @use_a.all.count < @numb_vehicles && @use_b_near_service.all.count < @a && @use_b_air_filter_service_near.all.count < @b && @use_b_a_service_near_1.all.count < @c && @use_b_shock_service_near_1.all.count < @d && @use_b_air_filter_service.all.count < @e && @use_b_a_service_near_2.all.count < @f && @use_b_a_service.all.count < @g && @use_b_shock_service_near_2.all.count < @h && @use_b_shock_service.all.count < @i && @use_b_near_service_nas.all.count < @j && @use_b_air_filter_service_near_nas.all.count < @k && @use_b_a_service_near_1_nas.all.count < @l && @use_b_shock_service_near_1_nas.all.count < @m && @use_b_air_filter_service_nas.all.count < @n && @use_b_a_service_near_2_nas.all.count < @o && @use_b_a_service_nas.all.count < @p && @use_b_shock_service_near_2_nas.all.count < @q && @use_b_shock_service_nas.all.count < @r && @use_b_near_service_nss.all.count < @s && @use_b_air_filter_service_near_nss.all.count < @t && @use_b_a_service_near_1_nss.all.count < @u && @use_b_shock_service_near_1_nss.all.count < @v && @use_b_air_filter_service_nss.all.count < @w && @use_b_a_service_near_2_nss.all.count < @x && @use_b_a_service_nss.all.count < @y && @use_b_shock_service_near_2_nss.all.count < @z && @use_b_shock_service_nss.all.count < @aa && @use_b_near_service_nass.all.count < @ab && @use_b_air_filter_service_near_nass.all.count < @ac && @use_b_a_service_near_1_nass.all.count < @ad && @use_b_shock_service_near_1_nass.all.count < @ae && @use_b_air_filter_service_nass.all.count < @af && @use_b_a_service_near_2_nass.all.count < @ag && @use_b_a_service_nass.all.count < @ah && @use_b_shock_service_near_2_nass.all.count < @ai && @use_b_shock_service_nass.all.count >= @aj 
  
  @use_a.order(times_used: :asc).limit(@use_a.all.count).each do |vehicle|
    @event_vehicles << vehicle.id
  end

  @use_b_near_service.order(times_used: :asc).limit(@a).each do |vehicle|
    @event_vehicles << vehicle.id        
  end
  @use_b_air_filter_service_near.order(times_used: :asc).limit(@b).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_a_service_near_1.order(times_used: :asc).limit(@c).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_shock_service_near_1.order(times_used: :asc).limit(@d).each do |vehicle|
    @event_vehicles << vehicle.id
  end
  @use_b_air_filter_service.order(times_used: :asc).limit(@e).each do |vehicle|
    @event_vehicles << vehicle.id
  end
@use_b_a_service_near_2.order(times_used: :asc).limit(@f).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service.order(times_used: :asc).limit(@g).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2.order(times_used: :asc).limit(@h).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service.order(times_used: :asc).limit(@i).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nas.order(times_used: :asc).limit(@j).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nas.order(times_used: :asc).limit(@k).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nas.order(times_used: :asc).limit(@l).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nas.order(times_used: :asc).limit(@m).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nas.order(times_used: :asc).limit(@n).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nas.order(times_used: :asc).limit(@o).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nas.order(times_used: :asc).limit(@p).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nas.order(times_used: :asc).limit(@q).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nas.order(times_used: :asc).limit(@r).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nss.order(times_used: :asc).limit(@s).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nss.order(times_used: :asc).limit(@t).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nss.order(times_used: :asc).limit(@u).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nss.order(times_used: :asc).limit(@v).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nss.order(times_used: :asc).limit(@w).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nss.order(times_used: :asc).limit(@x).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nss.order(times_used: :asc).limit(@y).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nss.order(times_used: :asc).limit(@z).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nss.order(times_used: :asc).limit(@aa).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_near_service_nass.order(times_used: :asc).limit(@ab).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_near_nass.order(times_used: :asc).limit(@ac).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_1_nass.order(times_used: :asc).limit(@ad).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_1_nass.order(times_used: :asc).limit(@ae).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_air_filter_service_nass.order(times_used: :asc).limit(@af).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_near_2_nass.order(times_used: :asc).limit(@ag).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_a_service_nass.order(times_used: :asc).limit(@ah).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_near_2_nass.order(times_used: :asc).limit(@ai).each do |vehicle|
  @event_vehicles << vehicle.id
end
@use_b_shock_service_nass.order(times_used: :asc).limit(@aj).each do |vehicle|
  @event_vehicles << vehicle.id
end

else
  @event.update(vehicle_ids: [])
  end
     @event.update(vehicle_ids: @event_vehicles)
     
     if @event.vehicles == []
       flash[:alert] = "Insufficient number of vehicles at current location. Please move vehicles to this location or maunally select vehicles."
     else
       flash[:notice] = "Vehicles successfully added!"
     end
     redirect_back(fallback_location: root_path)
  end
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
          vehicle.update(use_near_service: true, dont_use_a_service: false)
        else
          vehicle.update(dont_use_a_service: false)
        end
      end
          if vehicle.last_shock_service != nil
            @shock_service = (@set_shock_service.interval - ((vehicle.mileage + vehicle.est_mileage) - vehicle.last_shock_service))
            if @shock_service < 0
              vehicle.update(use_b: true, use_a: false, dont_use_shock_service: true)
            elsif @shock_service <= 200
              vehicle.update(use_near_service: true, dont_use_shock_service: false)
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
             vehicle.update(use_near_service: true, dont_use_air_filter_service: false)
           else
             vehicle.update(dont_use_air_filter_service: false)
           end
         end
   
         
       if vehicle.use_a == true && vehicle.times_used >= 5
         vehicle.update(use_a: false, use_b: true)
       elsif vehicle.use_b == true && vehicle.times_used >= 10
         vehicle.update(use_a: false, use_b: false)
       end
      
       if vehicle.needs_service == true
         vehicle.update(use_a: false, use_b: true)
       end
       
       if vehicle.near_service == true
         vehicle.update(use_a: false, use_b: true)
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
      params.require(:event).permit(:date, :event_mileage, :location, :event_time, :duration, :duration_word, :event_type, :est_mileage, :customers, :shares, :class_type, :number, :status, vehicle_ids: [])
    end
    
    
end
