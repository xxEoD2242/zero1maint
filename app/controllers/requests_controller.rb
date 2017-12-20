class RequestsController < ApplicationController
  before_action :authenticate_user!
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
  
  def overdue
    @set_overdue = Tracker.find_by(track: "Overdue")
    @q = Request.where(tracker_id: @set_overdue.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page]) 
  end

  def completed_requests
    @q = Request.where(tracker_id: @set_completed.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def new_requests
    @set_new = Tracker.find_by(track: "New")
    @q = Request.where(tracker_id: @set_new.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  def in_progress
    
    @q = Request.where(tracker_id: @set_progress.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end
  
  # GET /requests/1
  # GET /requests/1.json
  def show
    @part_items = PartItem.where(request_id: @request.id)
    @q = Part.ransack(params[:q])
    @parts = @q.result.page(params[:page])
    @part_order = RequestPartOrder.where(request_id: @request.id)
    respond_to do |format|
        format.html
        format.csv { send_data @vehicle_results.to_csv }
        format.xls
        format.pdf do
          render pdf: "Request #{@request.id}", :layout => 'pdf.pdf.erb', title: "Request #{@request.id}"  # Excluding ".pdf" extension.
        end
      end
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
    if part_quant == nil
      flash[:alert] = "Quantity of part unkown. Please update quantity in Parts Dashboard and try again."
    elsif part_quant > 0
      part_item = PartItem.create(part_id: params[:part_id], quantity: params[:quantity], request_id: params[:request_id])
      part_item.update(part_item_total: (part_item.quantity * part_item.part.cost))
      flash[:notice] = "Part successfully added to cart!"
    else
      flash[:alert] = "Part Out of Stock!"
    end
     
    redirect_back(fallback_location: root_path)
  end
  
  def delete_parts
    part_item = PartItem.find(params[:id])
    part_item.destroy
    if part_item.destroy
    flash[:notice] = "Part successfully removed from cart!"
    end
    redirect_back(fallback_location: root_path)
  end
  
  def remove_parts_from_request
    @part_orders = RequestPartOrder.where(request_id: params[:request_id])
    @part_orders.each do |part_order|
        if part_order.order_items.has_key?(params[:key])
          part_order.destroy
        end
     end
   redirect_back(fallback_location: root_path)
  end
  
  def add_parts
    part_items = PartItem.where(request_id: params[:request_id])
    if part_items.length != 0
      @part_order = RequestPartOrder.new(user_id: current_user.id, request_id: params[:request_id], order_total: 0)
      part_items.each do |part_item|
        part_item.part.update(quantity: (part_item.part.quantity - part_item.quantity))
        @part_order.order_items[part_item.part_id] = part_item.quantity 
        @part_order.order_total += part_item.part_item_total
    end
      @part_order.save
      @part_order.order_items.each do |key, value|
      PartRequest.create(part_id: Part.find(key).id, request_id: @part_order.request_id)
    end  
      part_items.destroy_all 
    end
    if @part_order != nil
      flash[:notice] = "Parts successfully added to work order!"
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
    @a_service = Program.find_by(name: "A-Service")
    @shock_service = Program.find_by(name: "Shock Service")
    @air_filter_service = Program.find_by(name: "Air Filter Change")
     @set_completed = Tracker.find_by(track: "Completed")
    
    @repairs = Program.find_by(name: "Repairs")
    @defects = Program.find_by(name: "Defect")
    @set_new = Tracker.find_by(track: "New")
    respond_to do |format|
      
      if @request.save
        @veh_mileage = @request.vehicle.mileage
        if @request.program_id == @a_service.id
          @request.vehicle.update(last_a_service: @veh_mileage)
        elsif @request.program_id == @shock_service.id
          @request.vehicle.update(last_shock_service: @veh_mileage)
         elsif @request.program_id == @air_filter_service.id
           @request.vehicle.update(last_air_filter_service: @veh_mileage)
        elsif @request.program_id == @repairs.id && @request.tracker_id == @set_new.id
          @request.vehicle.update(repair_needed: true, needs_service: true, vehicle_status: "Out-of-Service")
        elsif @request.program_id == @defects.id && @request.tracker_id == @set_new.id
          @request.vehicle.update(defect: true, needs_service: true, vehicle_status: "Out-of-Service")
          if @request.users.exists?
            defect_emails = []
            @request.users.all.each do |user|
              defect_emails << user.email
            end
          UserMailer.new_request_email(defect_emails, @request).deliver_now
        end
      end
        unless @request.program_id == @defects.id && @request.tracker_id == @set_new.id
        if @request.users.exists?
          emails = []
          @request.users.all.each do |user|
            emails << user.email
          end
          UserMailer.assign_request_email(emails, @request).deliver_now
        end
      end
        
        format.html { redirect_to @request, notice: 'Work Order was successfully created.' }
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
    @a_service = Program.find_by(name: "A-Service")
    @shock_service = Program.find_by(name: "Shock Service")
    @air_filter_service = Program.find_by(name: "Air Filter Change")
    @set_completed = Tracker.find_by(track: "Completed")
    respond_to do |format|
      if @request.update(request_params)
        vehicle = @request.vehicle
        @veh_mileage = @request.vehicle.mileage
        if @request.program_id == @a_service.id && @request.tracker_id == @set_completed.id
          @request.vehicle.update(last_a_service: @veh_mileage)
        elsif @request.program_id == @shock_service.id && @request.tracker_id == @set_completed.id
          @request.vehicle.update(last_shock_service: @veh_mileage)
         elsif @request.program_id == @air_filter_service.id && @request.tracker_id == @set_completed.id
           @request.vehicle.update(last_air_filter_service: @veh_mileage)
        elsif @request.program_id == @repairs.id && @request.tracker_id == @set_completed.id
          vehicle.update(repair_needed: false, vehicle_status: "In-Service")
        elsif @request.program_id == @defects.id && @request.tracker_id == @set_completed.id
          vehicle.update( defect: false, vehicle_status: "In-Service")
        end
        
        if @request.users.exists?
          emails = []
          @request.users.all.each do |user|
            emails << user.email
          end
          UserMailer.assign_request_email(emails, @request).deliver_now
        end
      
        
        format.html { redirect_to @request, notice: 'Work Order was successfully updated.' }
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
      params.require(:request).permit(:number, :description, :special_requets, :completion_date, :completed_date, :poc, :checklist_numb, :creator, :vehicle_id, :tracker_id, :image, :creator, :request_mileage, :program_id, part_ids: [], user_ids: [])
    end
end
