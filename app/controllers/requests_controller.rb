class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :set_vehicle, :set_tracker, only: [:index, :show, :edit, :new]
  before_action :set_services, :set_tracker, only: [:show, :index, :new, :edit, :dashboard, :a_service, :shock_service, :air_filter_service, :defects, :repairs, :completed_requests, :in_progress]
  before_action :a_service, :shock_service, :air_filter_service, :repairs, :defects, only: [:dashboard]
  before_action :check_quant, only: [:show]
 
  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all.page(params[:page])
    @q = Request.ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def completed_requests
    @q = Request.where(tracker_id: @set_completed.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def in_progress
    @q = Request.where(tracker_id: @set_progress.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def defects
    @requests = Request.where(program_id: 5)
    @q = Request.where(tracker_id: 5).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  # GET /requests/1
  # GET /requests/1.json
  def show
    @part_items = PartItem.where(request_id: @request.id)
    @q = Part.ransack(params[:q])
    @parts = @q.result.page(params[:page])
    @part_order = RequestPartOrder.where(request_id: @request.id)
  end
  
  def a_service
    @a_service = Program.find_by(name: "A-Service")
    @a_service_requests = Request.where(program_id: @a_service.id)
    @q = Request.where(program_id: @a_service.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def shock_service
    @shock_service = Program.find_by(name: "Shock Service")
    @shock_service_requests = Request.where(program_id: @shock_service.id)
    @q = Request.where(program_id: @shock_service.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def air_filter_service
    @air_filter_service = Program.find_by(name: "Air Filter Change")
    @air_filter_requests = Request.where(program_id: @air_filter_service.id)
    @q = Request.where(program_id: @air_filter_service).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def repairs

    @repairs = Program.find_by(name: "Repairs")
    @repair_requests = Request.where(program_id: @repairs.id)
    @q = Request.where(program_id: @repairs.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def defects
    @defects = Program.find_by(name: "Defect")
    @defect_requests = Request.where(program_id: @defects.id)
    @q = Request.where(program_id: @defects.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def dashboard
    @requests = Request.all
  end
  
  def add_to_request_part_order
    part_quant = Part.find(params[:part_id]).quantity
    if part_quant > 0
      part_item = PartItem.create(part_id: params[:part_id], quantity: params[:quantity], request_id: params[:request_id])
      flash[:success] = "Part successfully added to cart!"
    else
      flash[:success] = "Part Out of Stock!"
       redirect_back(fallback_location: root_path)
    end
     
    redirect_back(fallback_location: root_path)
  end
  
  def delete_parts
    part_item = PartItem.find(params[:id])
    part_item.destroy
    redirect_back(fallback_location: root_path)
  end
  
  def add_parts
   
    part_items = PartItem.where(request_id: params[:request_id])
    if part_items.length != 0
      @part_order = RequestPartOrder.create(user_id: current_user.id, request_id: params[:request_id])

      part_items.each do |part_item|
        part_item.part.update(quantity: (part_item.part.quantity - part_item.quantity))
        @part_order.order_items[part_item.part_id] = part_item.quantity 
      end
      @part_order.save
      @part_order.order_items.each do |key, value|
      PartRequest.create(part_id: Part.find(key).id, request_id: @part_order.request_id)
      
    end  
      part_items.destroy_all
    
      
      
    end
    redirect_back(fallback_location: root_path)
  end
  
  def check_quant
    @part_quant = Part.where("quantity <= ?", 0)
    if @part_quant.ids  == Part.ids
      redirect_back(fallback_location: root_path)
    end  
  end
  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
    @q = Part.ransack(params[:q])
    @parts = @q.result.page(params[:page])
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    @repairs = Program.find_by(name: "Repairs")
    @defects = Program.find_by(name: "Defect")
    @set_new = Tracker.find_by(track: "New")
    respond_to do |format|
      
      if @request.save
        veh_mileage = @request.vehicle.mileage
        vehicle = @request.vehicle
        @request.update(request_mileage: (veh_mileage))
        if @request.program_id == @repairs.id && @request.tracker_id == @set_new.id
          vehicle.update(repair_needed: true, vehicle_status: "Out-of-Service")
        end
        if @request.program_id == @defects.id && @request.tracker_id == @set_new.id
          vehicle.update(repair_needed: true, vehicle_status: "Out-of-Service")
          UserMailer.new_request_email(current_user, @request).deliver_now
        end
        
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    @repairs = Program.find_by(name: "Repairs")
    @defects = Program.find_by(name: "Defect")
    @set_completed = Tracker.find_by(track: "Completed")
    respond_to do |format|
      if @request.update(request_params)
        vehicle = @request.vehicle
        if @request.program_id == @repairs.id && @request.tracker_id == @set_completed.id
          vehicle.update(repair_needed: false, vehicle_status: "In-Service")
        end
        if @request.program_id == @defects.id && @request.tracker_id == @set_completed.id
          vehicle.update(repair_needed: false, vehicle_status: "In-Service")
        end
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end
    
    def set_vehicle
      @vehicles = Vehicle.all
    end
    
    def set_services
      @a_service = Program.find_by(name: "A-Service")
      @shock_service = Program.find_by(name: "Shock Service")
      @air_filter_service = Program.find_by(name: "Air Filter Change")
      @repairs = Program.find_by(name: "Repairs")
      @defects = Program.find_by(name: "Defect")
    end
    
    
    def set_tracker
      @tracks = Tracker.all
      @set_new = Tracker.find_by(track: "New")
      @set_progress = Tracker.find_by(track: "In-Progress")
      @set_completed = Tracker.find_by(track: "Completed")
      @set_overdue = Tracker.find_by(track: "Overdue")
    end
    
    def set_services
      @programs = Program.all
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    
    def request_params
      params.require(:request).permit(:number, :description, :special_requets, :completion_date, :poc, :vehicle_id, :tracker_id, :image, :user_id, :request_mileage, :program_id, part_ids: [])
    end
end
