class ChecklistsController < ApplicationController
  before_action :set_checklist, only: [:show, :edit, :update, :destroy]
  
  def index
  end
  
  def new
    @vehicle = Vehicle.find(params[:id])
    @event = Event.find(params[:event_id])
    @checklist = Checklist.new
  end
  
  def show
  end

  def edit
    @vehicle = @checklist.vehicle
    @event = @checklist.event
  end

  def records
    @q = Event.all.ransack(params[:q])
    @events = @q.result.page(params[:page])
  end

  def create
    @checklist = Checklist.new(checklist_params)
    @set_repairs = Program.find_by(name: "Repairs")
    @set_new = Tracker.find_by(track: "New")
    @vehicle = @checklist.vehicle
    respond_to do |format|
      if @checklist.save
        @checklist.update(completed: true)
        if @checklist.deadline == true
          @vehicle.update(vehicle_status: "Out-of-Service")
          Request.create(id: Request.last.id + 1, tracker_id: @set_new.id, description: "Vehicle failed pre-operation inspection. Please refer to checklist for defects detected or repairs needed.", vehicle_id: @vehicle.id, user_id: current_user.id, program_id: @set_repairs.id, completion_date: (Time.now + 7.days), checklist_numb: @checklist.id)
        end
        format.html { redirect_to @checklist, notice: 'Checklist was successfully created.' }
        format.json { render :show, status: :created, location: @checklist }
      else
        format.html { render :new }
        format.json { render json: @checklist.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @checklist.update(checklist_params)
        format.html { redirect_to @checklist, notice: 'Checklist was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @checklist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Checklist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
 
  private
  
  def set_checklist
    @checklist = Checklist.find(params[:id])
  end
  
  
  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end
  
  def checklist_params
    params.require(:checklist).permit(:date, :user_id, :event_id, :vehicle_id, :fuel_level, :wash, :deadline, :suspension, :drive_train, :body, :engine, :brake, :safety_equipment, :chassis, :electrical, :cooling_system, :tires, :radio, :exhaust, :steering, :comments, :completed)
  end
end
