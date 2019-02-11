# frozen_string_literal: true

class ChecklistsController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_checklist, only: %i[show edit update destroy]

  def index; end

  def new
    defect_method_notice
    @vehicle = Vehicle.find(params[:id])
    @defects = @vehicle.defects.where(fixed: false)
    @event = Event.find(params[:event_id])
    @checklist = Checklist.new
  end
  
  def defect_method_notice
    flash[:notice] = "Please be advised. The method to add defects to a checklist has been changed.
                      Please view the informational message above the defects table."
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
    defect_method_notice
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
                     completion_date: (Time.now + 7.days), deadline: true, request_mileage: @vehicle.mileage,
                     checklist_id: checklist.id, completed_date: Date.current)
    end
  end

  def records
    @q = Event.all.ransack(params[:q])
    @events = @q.result.page(params[:page])
  end

  def create_defect(checklist)
    @last_defect_id = Defect.last.id
    current_ids = create_id_comparator    # Builds an array with 1..100000 which is used as a comparator to ensure that ids entered are numbers
    maintenance = create_maint_categories # Builds an array with the categories that are needed to create defects
    checklist.attributes.each do |k, v|
      if v != 'Checked' && maintenance.include?(k) && !current_ids.include?(v)
        @new_defect = Defect.create(description: v, checklist_ids: [checklist.id], vehicle_id: checklist.vehicle.id,
                                    manually_reported: false, category: k, times_reported: 0, times_completed: 0, last_event_reported: checklist.event_id)
      elsif v != 'Checked' && maintenance.include?(k) && current_ids.include?(v)
        if v.to_i < @last_defect_id
        @defect = Defect.where(id: v).last
        @defect.update(times_reported: (@defect.times_reported + 1), last_event_reported: checklist.event_id, checklist_ids: [checklist.id])
        end
      end
    end
  end

  # This function copies the information that was entered into the completed checklist for the vehicle.
  # The duplicate set of data is then used for comparison when determining if any information was added
  # to a checklist after the initial creation.
  def copy_parameters(checklist)
    checklist.update(wash_old: checklist.wash, suspension_old: checklist.suspension, drive_train_old: checklist.drive_train, 
                     body_old: checklist.body, engine_old: checklist.engine, brakes_old: checklist.brakes, safety_equipment_old: checklist.safety_equipment,
                     chassis_old: checklist.chassis, electrical_old: checklist.electrical, cooling_system_old: checklist.cooling_system,
                     tires_old: checklist.tires, radio_old: checklist.radio, exhaust_old: checklist.exhaust, steering_old: checklist.steering, defect_ids_old: checklist.defect_ids)
  end
  
  def update_count_defects(checklist)
    if !checklist.defects.empty? 
      checklist.defects.each do |defect|
        if !checklist.defect_ids_old.include?(defect.id.to_s)
          defects_count_update defect, checklist
        end
      end
    end
  end
  
  def defects_count_update(defect, checklist)
     defect.update(times_reported: (defect.times_reported + 1), last_event_reported: checklist.event_id, checklist_ids: [checklist.id])
  end
  
  def count_defects(checklist)
    if !checklist.defects.empty? 
      checklist.defects.each do |defect|
        defects_count_update defect, checklist
      end
    end
  end
  
  def create_id_comparator
    current_ids = []
    (1..100000).each do |numb|
      string = numb.to_s
      current_ids << string
    end
    return current_ids
  end
  
  def create_maint_categories
    %w[engine suspension steering tires
      radio chassis exhaust cooling_system
      electrical safety_equipment brakes body
      drive_train]
  end
  
  def update_defects(checklist)
    @last_defect_id = Defect.last.id
    current_ids = create_id_comparator
    maintenance = create_maint_categories

    checklist.attributes.each do |k, v|
      if maintenance.include?(k)
        checklist_key = (k + "_old")
        old_checklist = checklist.attributes[checklist_key]
      end
      if v != 'Checked' && maintenance.include?(k) && !current_ids.include?(v) && v != old_checklist && v != ""
        @new_defect = Defect.create(description: v, checklist_ids: [checklist.id], vehicle_id: checklist.vehicle.id,
                                    manually_reported: false, category: k, times_completed: 0, times_reported: 0, last_event_reported: checklist.event_id)
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
        deadlined @checklist        # If the vehicle is deadlined, create a new work order automatically
        create_defect @checklist    # Look at all fields and see if there is a new defect that needs to be created
        count_defects @checklist    # Update times reported for any defect that was attached
        copy_parameters @checklist  # Copy all fields to be able to perform checking
        format.html { redirect_to @checklist, notice: 'Checklist was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @checklist.update(checklist_params)
        update_defects @checklist       # Create a new defect or update old defects if new information was entered
        update_count_defects @checklist # Update the number of times reported for any newly attached defects
        copy_parameters @checklist      # Copy the new information into records for comparison
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
