# frozen_string_literal: true

class ChecklistsController < ApplicationController
  before_action :set_checklist, only: %i[show edit update destroy]

  def index; end

  def new
    @vehicle = Vehicle.find(params[:id])
    @defects = @vehicle.defects.where(fixed: false).page(params[:page])
    @event = Event.find(params[:event_id])
    @checklist = Checklist.new
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'Checklist',
               layout: 'pdf.pdf.erb',
               title: "Checklist for #{@checklist.vehicle.car_id} for Event #{@checklist.event.id}"
      end
    end
  end

  def create_work_order
    @checklist = Checklist.find(params[:checklist_id])
    @vehicle = Vehicle.find(params[:vehicle_id])
    @repairs = Program.find_by(name: 'Repairs')
    @request = Request.create(status: 'New', program_id: @repairs.id,
                              description: '****** Please fill this in ******',
                              request_mileage: @vehicle.mileage,
                              vehicle_id: @vehicle.id, creator: User.find(@checklist.user.id).name,
                              completion_date: (Time.now + 7.days),
                              checklist_id: @checklist.id, completed_date: Date.current)
    if @request.save
      flash[:notice] = 'Work Order Created! Please select Service, Status and enter dates.'
    else
      flash[:alert] = 'Could not create Work Order!'
    end
    redirect_to edit_request_path(id: @request.id)
  end

  def edit
    @vehicle = @checklist.vehicle
    @event = @checklist.event
    @defects = @vehicle.defects.where(fixed: false).page(params[:page])
  end

  def records
    @q = Event.all.ransack(params[:q])
    @events = @q.result.page(params[:page])
  end

  def create
    @checklist = Checklist.new(checklist_params)
    respond_to do |format|
      if @checklist.save

        format.html { redirect_to @checklist, notice: 'Checklist was successfully created.' }
        format.json { render :show, status: :created, location: @checklist }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @checklist.update(checklist_params)
        format.html { redirect_to @checklist, notice: 'Checklist was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Checklist was successfully destroyed.' }
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
    params.require(:checklist).permit(:date, :user_id, :event_id, :vehicle_id, :fuel_level,
                                      :wash, :deadline, :suspension, :drive_train, :body,
                                      :engine, :brake, :safety_equipment, :chassis, :electrical,
                                      :cooling_system, :tires, :radio, :exhaust, :steering,
                                      :comments, :completed, :defect, defect_ids: [])
  end
end
