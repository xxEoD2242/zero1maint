# frozen_string_literal: true

class DefectsController < ApplicationController
  before_action :set_all_vehicles, only: [:by_event, :index]

  def show
    
  end

  def new
 
  end

  def edit
    
  end
 
  def fixed
    @defects = Defect.where(fixed: true)
  end

  def by_vehicle
    @vehicle = Vehicle.find(params[:id])
    @q = @vehicle.defects.ransack(params[:q])
    @defects = @q.result.order(fixed: :desc).page(params[:page])
  end

  def create_defect_work_order
    @checklist = Checklist.find(params[:checklist_id])
    @vehicle = Vehicle.find(params[:vehicle_id])
    @defect = Program.find_by(name: 'Defect')
    @request = Request.create(status: 'New', program_id: @defect.id,
                              description: '****** Please fill this in ******',
                              request_mileage: @vehicle.mileage, vehicle_id: @vehicle.id,
                              creator: User.find(@checklist.user.id).name,
                              completion_date: (Time.now + 7.days), checklist_id: @checklist.id, 
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
    to_pdf "Defects by event for #{Date.current.strftime('%v')} "
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
    params.require(:defect).permit(:date_fixed, :vehicle_id, :checklist_id, :request_id, :fixed, :description, :category)
  end
end
