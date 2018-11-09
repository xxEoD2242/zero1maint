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
  
  def deadlined(checklist)
    # Add in the ability to attach defects to the Work Order when this automatically created.
    @set_repairs = Program.find_by(name: 'Repairs')
    @vehicle = checklist.vehicle
    if checklist.deadline
      @vehicle.update(vehicle_status: 'Out-of-Service', repair_needed: true)
      Request.create(status: 'New',
                     description: 'Vehicle failed pre-operation inspection. Please refer to checklist for defects detected or repairs needed.',
                     vehicle_id: @vehicle.id, creator: User.find(checklist.user_id).name, program_ids: [@set_repairs.id],
                     completion_date: (Time.now + 7.days), request_mileage: @vehicle.mileage,
                     checklist_id: checklist.id, completed_date: Date.current)
    end
  end
  
  def create_defect(checklist)
    current_ids = []
    (1..100000).each do |numb|
      string = numb.to_s
      current_ids << string
    end
    @last_defect_id = Defect.last.id
    maintenance = %w[engine suspension steering tires
                     radio chassis exhaust cooling_system
                     electrical safety_equipment brakes body
                     drive_train suspension]
    checklist.attributes.each do |k, v|
      if v != 'Checked' && maintenance.include?(k) && !current_ids.include?(v)
        @new_defect = Defect.create(description: v, checklist_ids: [checklist.id], vehicle_id: checklist.vehicle.id,
                                    manually_reported: false, category: k, times_reported: 0, last_event_reported: checklist.event_id)
      elsif v != 'Checked' && maintenance.include?(k) && current_ids.include?(v)
        if v.to_i < @last_defect_id
        @defect = Defect.where(id: v).last
        @defect.update(times_reported: (@defect.times_reported + 1), last_event_reported: checklist.event_id, checklist_ids: [checklist.id])
        end
      end
    end
  end

  def records
    @q = Event.all.ransack(params[:q])
    @events = @q.result.page(params[:page])
  end
  
  def copy_parameters(checklist)
    checklist.update(wash_old: checklist.wash, suspension_old: checklist.suspension, drive_train_old: checklist.drive_train, 
                     body_old: checklist.body, engine_old: checklist.engine, brakes_old: checklist.brakes, safety_equipment_old: checklist.safety_equipment,
                     chassis_old: checklist.chassis, electrical_old: checklist.electrical, cooling_system_old: checklist.cooling_system,
                     tires_old: checklist.tires, radio_old: checklist.radio, exhaust_old: checklist.exhaust, steering_old: checklist.steering)
  end
  
  def update_defects(checklist)
    current_ids = []
    (1..100000).each do |numb|
      string = numb.to_s
      current_ids << string
    end
    @last_defect_id = Defect.last.id
    maintenance = %w[engine suspension steering tires
                     radio chassis exhaust cooling_system
                     electrical safety_equipment brakes body
                     drive_train suspension]
    checklist.attributes.each do |k, v|
      if maintenance.include?(k)
        checklist_key = (k + "_old")
        old_checklist = checklist.attributes[checklist_key]
      end
      if v != 'Checked' && maintenance.include?(k) && !current_ids.include?(v) && v != old_checklist && v != ""
        @new_defect = Defect.create(description: v, checklist_ids: [checklist.id], vehicle_id: checklist.vehicle.id,
                                    manually_reported: false, category: k, times_reported: 0, last_event_reported: checklist.event_id)
      elsif v != 'Checked' && maintenance.include?(k) && current_ids.include?(v) && v != old_checklist && v != ""
        if v.to_i < @last_defect_id
        @defect = Defect.where(id: v).last
        @defect.update(times_reported: (@defect.times_reported + 1), last_event_reported: checklist.event_id, checklist_ids: [checklist.id])
        end
      elsif v != 'Checked' && maintenance.include?(k) && current_ids.include?(old_checklist) && v != old_checklist && v == ""
        @defect = Defect.where(id: checklist.attributes[checklist_key]).last
        @defect.update(times_reported: (@defect.times_reported - 1))
      elsif v != 'Checked' && maintenance.include?(k) && !current_ids.include?(v) && v != old_checklist && v == ""
        @defect = Defect.where(vehicle_id: checklist.vehicle_id, description: checklist.attributes[checklist_key]).last
        @defect.destroy
      end
    end
  end

  def create
    @checklist = Checklist.new(checklist_params)
    respond_to do |format|
      if @checklist.save
        deadlined @checklist
        create_defect @checklist
        copy_parameters @checklist
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
        update_defects @checklist
        copy_parameters @checklist
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
                                      :engine, :brakes, :safety_equipment, :chassis, :electrical,
                                      :cooling_system, :tires, :radio, :exhaust, :steering,
                                      :comments, :completed, :defect, defect_ids: [])
  end
end
