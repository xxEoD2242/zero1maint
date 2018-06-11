class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :calc_mileage]
  before_action :set_location, only: [:index, :show, :edit, :new, :create, :update]
  before_action :set_vehicles, only: [:index, :show, :edit, :new, :create, :update]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: [:vehicle_rotation, :new, :edit]
  before_action :vehicle_rotation, only: [:edit]
  after_action :calc_mileage, only: [:update, :event_completed]
  after_action :multi_day, only: [:create]
  include Auto_Select, Vehicle_Rotation, Multi_Day
  

  def index
    @q = Event.all.ransack(params[:q])
    @event_results = @q.result.includes(:vehicles).page(params[:page])
  end

  def show
    @checklists = Checklist.where(event_id: @event.id)
    respond_to do |format|
         format.html
         format.xls
         format.pdf do
           render pdf: "Event #\: #{@event.id} ", :layout => 'pdf.pdf.erb', :title => "Event #\: #{@event.id}"  # 
         end
       end
  end
  
  def json_data
    render json:  @json_data = HTTParty.get('https://zero-1-maint.herokuapp.com/:bookings', :headers =>{'Content-Type' => 'application/json'} )
  end
  
  def vehicle_rotation_metrics
    
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
  
  def previous_month
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @prev_month = @date - 1.month
    @events = Event.where('date <= ?', @prev_month - 1.month)
    @display_events = @events.where('date >= ?', @prev_month)
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
  
  def event_completed
    @event = Event.find(params[:event_id])
    @event.update(status: 'Completed', event_mileage: params[:event_mileage])
    event_mileage = @event.event_mileage
    calc_mileage = @event.calc_mileage
    
    if calc_mileage == 0 
      @event.vehicles.each do |vehicle|
        vehicle.update(mileage: (vehicle.mileage + event_mileage))
      end
    end
    
    
    if calc_mileage != 0
      @event.vehicles.each do |vehicle|
        vehicle.update(mileage: (vehicle.mileage + (event_mileage - calc_mileage)))
      end
    end
  
    flash[:notice] = "Event successfully completed!"
    redirect_back(fallback_location: root_path)
  end
  
  
  def edit
    @vehicles = Vehicle.all
    @vehicle_categories = VehicleCategory.all
  end

  def calc_mileage
    @event.update(calc_mileage: @event.event_mileage)
  end


  def create
    @event = Event.new(event_params)
    respond_to do |format|
      
      if @event.save
        @event.update(calc_mileage: 0)
        
        # if @event.multi_day == true
          #numb_days = (@event.scheduled_date - @event.end_day).to_i
          #days = 0
         # loop do
          #Event.create()
          #days += 1
          #end
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
        calc_mileage = @event.calc_mileage
        
        if calc_mileage == 0 
          @event.vehicles.each do |vehicle|
            vehicle.update(mileage: (vehicle.mileage + event_mileage))
          end
        end
        
        
        if calc_mileage != 0
          @event.vehicles.each do |vehicle|
            vehicle.update(mileage: (vehicle.mileage + (event_mileage - calc_mileage)))
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

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
   
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

    def event_params
      params.require(:event).permit(:date, :event_mileage, :location, :event_time, :duration, :end_date, :duration_word, :event_type, :multi_day, :est_mileage, :customers, :calc_mileage, :shares, :class_type, :number, :status, vehicle_ids: [])
    end  
end
