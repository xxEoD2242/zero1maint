# frozen_string_literal: true

class DefectsController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_all_vehicles, only: [:by_event, :new, :edit, :index]
  before_action :set_defect, only: [:show, :edit, :update, :destroy]

  def show;end

  def new
    @defect = Defect.new
    @vehicles = Vehicle.all
  end

  def edit;end
 
  def fixed
    @defects = Defect.where(fixed: true)
  end

  def another
    @vehicle = Vehicle.find(params[:vehicle_id])
    @checklist = Checklist.find(params[:checklist_id])
    @defect = Defect.create(description: '**** Please fill this in! ****', vehicle_id: @vehicle.id,
                            fixed: false, checklist_ids: [@checklist.id],
                            manually_reported: true, times_reported: 0, times_completed: 0)
    
    if @defect.save
      flash[:notice] = 'Defect Created! Please fill in the remaining information'
    else
      flash[:alert] = 'Could not create Defect!'
    end              
    redirect_to edit_defect_path(id: @defect.id)                       
  end

  def report
    @vehicle = Vehicle.find(params[:vehicle_id])
    @defect = Defect.create(description: '**** Please fill this in! ****', vehicle_id: @vehicle.id, fixed: false,
                            manually_reported: true, times_reported: 0, times_completed: 0)
    if @defect.save
      flash[:notice] = 'Defect Created! Please fill in the remaining information'
    else
      flash[:alert] = 'Could not create Defect!'
    end              
    redirect_to edit_defect_path(id: @defect.id)            
  end

  def create_defect_work_order
    @checklist = Checklist.find(params[:checklist_id])
    @vehicle = Vehicle.find(params[:vehicle_id])
    @defect = Program.find_by(name: 'Defect')
    @request = Request.create(status: 'New', program_id: @defect.id, program_ids: [@defect.id],
                              description: '****** Please fill this in ******',
                              request_mileage: @vehicle.mileage, vehicle_id: @vehicle.id, vehicle_ids: [@vehicle.id],
                              creator: User.find(current_user.id).name,
                              completion_date: (Time.now + 7.days), checklist_id: @checklist.id, 
                              defect_ids: [params[:defect_id]], completed_date: Date.current)
    if @request.save
      flash[:notice] = 'Defect Work Order Created! Please select Service, Status and enter dates.'
    else
      flash[:alert] = 'Could not create Work Order!'
    end
    redirect_to edit_request_path(id: @request.id)
  end
  
  def create_manual_defect_work_order
    @vehicle = Vehicle.find(params[:vehicle_id])
    @defect = Program.find_by(name: 'Defect')
    @request = Request.create(status: 'New', program_id: @defect.id, program_ids: [@defect.id],
                              description: '****** Please fill this in ******',
                              request_mileage: @vehicle.mileage, vehicle_id: @vehicle.id, vehicle_ids: [@vehicle.id],
                              creator: User.find(current_user.id).name,
                              completion_date: (Time.now + 7.days), 
                              defect_ids: [params[:defect_id]], completed_date: Date.current)
    if @request.save
      flash[:notice] = 'Defect Work Order Created! Please select Service, Status and enter dates.'
    else
      flash[:alert] = 'Could not create Work Order!'
    end
    redirect_to edit_request_path(id: @request.id)
  end
  
  def by_event
    @q = Event.defects_reported?.ransack(params[:q])
    @event_results = @q.result.order(id: :desc).page(params[:page])
    to_pdf "Defects by event for #{Date.current.strftime('%v')}"
  end

  def index
    @q = Defect.all.order(id: :desc).ransack(params[:q])
    @defects = @q.result.page(params[:page])
    to_pdf "All Defects for #{Date.current.strftime('%v')} "
  end
  
  def to_pdf(header)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: header,
               layout: 'pdf.pdf.erb',
               title: header
      end
    end
  end

  def create
    @defect = Defect.new(defect_params)
    respond_to do |format|
      if @defect.save
        format.html { redirect_to @defect, notice: 'Defect was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @defect.update(defect_params)
        format.html { redirect_to @defect, notice: 'Defect was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @defect.destroy
    respond_to do |format|
      format.html { redirect_to defects_url, notice: 'Defect was successfully destroyed.' }
    end
  end

  private
  
  def set_all_vehicles
    @vehicles = Vehicle.all
  end

  def set_defect
    @defect = Defect.find(params[:id])
  end

  def defect_params
    params.require(:defect).permit(:date_fixed, :vehicle_id, :request_id, :fixed, :description,
                                   :manually_reported, :category, :repair, :notes, :creator, :mechanic, :user_id,
                                   :times_completed, :times_reported, checklist_ids: [])
  end
end
