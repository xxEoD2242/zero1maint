# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy calc_mileage]
  before_action :set_location, only: %i[index show edit new create update]
  before_action :set_vehicles, only: %i[index show edit new create update]
  before_action :set_a_service, :set_shock_service, :set_air_filter_service, :set_repairs, :set_defects, only: %i[vehicle_rotation new edit]
  before_action :vehicle_rotation, only: [:edit]
  after_action :calc_mileage, only: %i[update event_completed]
  include Multi_Day
  include Vehicle_Rotation
  include Auto_Select

  def index
    @q = Event.all.ransack(params[:q])
    @event_results = @q.result.includes(:vehicles).page(params[:page])
  end

  def show
    @event.set_checklists_completed
    @event.set_defects_reported
    @checklists = Checklist.where(event_id: @event.id)
    @vehicles = @event.vehicles
    respond_to do |format|
      format.html
      format.xls
      format.pdf do
        render pdf: "Event #\: #{@event.id} ", layout: 'pdf.pdf.erb', title: "Event #\: #{@event.id}"
      end
    end
  end

  def vehicle_rotation_metrics; end

  def dashboard
    @display_events = Event.where('date >= ? AND date <= ?', Date.current - 7.days, Date.current + 14.days)
    @set_completed_events = Event.where('date = ?', Date.current)
    @scheduled_events = Event.are_scheduled?
    @completed_events = Event.are_completed?
    @assigned_events = Event.where(status: 'Vehicles Assigned')
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @events_by_date = Event.group('events.id').group_by(&:date)
    @set_completed_events.all.each(&:set_checklists_completed)
  end

  def next_month_calendar
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @next_month = @date + 1.month
    @display_events  = Event.where('date <= ? AND date >= ?', @next_month + 1.month, @next_month)
    @scheduled_events = Event.where(status: 'Scheduled')
    @completed_events = Event.where(status: 'Completed')
    @assigned_events = Event.where(status: 'Vehicles Assigned')
    @events_by_date = Event.group('events.id').group_by(&:date)
  end

  def previous_month
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @prev_month = @date - 1.month
    @display_events = Event.where('date <= ? AND date >= ?', @prev_month - 1.month, @prev_month)
    @scheduled_events = Event.where(status: 'Scheduled')
    @completed_events = Event.where(status: 'Completed')
    @assigned_events = Event.where(status: 'Vehicles Assigned')
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

    flash[:notice] = 'Event successfully completed!'
    redirect_back(fallback_location: root_path)
  end

  def edit
    @vehicles = Vehicle.all
  end

  def calc_mileage
    @event.update(calc_mileage: @event.event_mileage)
  end
  
  def multi_day(event)
    numb_days = ((event.end_date.mjd - event.date.mjd) - 1)
    numb_days.times do
      Event.create(date: Event.last.date + 1.day, end_date: Event.last.end_date + 1.day,
                   customers: @event.customers, status: 'Scheduled', location: @event.location, 
                   est_mileage: @event.est_mileage, event_type: @event.event_type, 
                   class_type: @event.class_type, calc_mileage: 0, multi_day: false, 
                   shares: @event.shares, event_mileage: 0, duration: @event.duration, 
                   event_time: @event.event_time, duration_word: @event.duration_word)
    end
  end

  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        @event.update(calc_mileage: 0)
        if @event.multi_day
          multi_day @event
        end
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

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
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
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

  def event_params
    params.require(:event).permit(:date, :event_mileage, :location, :event_time,
                                  :duration, :end_date, :duration_word, :event_type,
                                  :multi_day, :est_mileage, :customers, :calc_mileage,
                                  :shares, :class_type, :defects_reported, :number, :status, vehicle_ids: [])
  end
end
