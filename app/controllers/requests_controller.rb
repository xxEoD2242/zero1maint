# frozen_string_literal: true

class RequestsController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :set_request, only: %i[show edit update destroy] 
  before_action :check_quant, only: [:show]

  def index
    @requests = Request.all.page(params[:page])
    @q = Request.ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def overdue
    @q = Request.where(status: 'Overdue').ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def completed
    @q = Request.where(status: 'Completed').ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def new_requests
    @q = Request.where(status: 'New').ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def in_progress
    @q = Request.where(status: 'In-Progress').ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def show
    @number = Part.count
    @counter = 0
    @part_items = PartItem.where(request_id: @request.id)
    @q = Part.ransack(params[:q])
    @parts = @q.result.page(params[:page])
    @part_order = RequestPartOrder.where(request_id: @request.id)
    respond_to do |format|
      format.html
      format.csv { send_data @vehicle_results.to_csv }
      format.xls
      format.pdf do
        render pdf: "Request #{@request.id}", layout: 'pdf.pdf.erb', title: "Request #{@request.id}" # Excluding ".pdf" extension.
      end
    end
  end

  def a_service
    @q = Request.is_an_a_service.ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def shock_service
    @q = Request.is_a_shock_service.ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def air_filter_service
    @q = Request.is_a_air_filter_service.ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def repairs
    @q = Request.is_a_repair.ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def defects
    @q = Request.is_a_defect.ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def tour_car_prep
    @q = Request.is_a_defect.ransack(params[:q])
    @request_results = @q.result.page(params[:page])
  end

  def dashboard
    @requests = Request.last(10).reverse
    @defects = Defect.count
    @all_wo_numb = Request.count
    @new_wo_numb = Request.is_new.size
    @in_progress_wo_numb = Request.is_in_progress.size
    @overdue_wo_numb = Request.is_overdue.size
    @completed_wo_numb = Request.is_completed.size
    @a_service_wo_numb = Request.is_an_a_service.size
    @shock_service_wo_numb = Request.is_a_shock_service.size
    @air_filter_service_wo_numb = Request.is_a_air_filter_service.size
    @repairs_wo_numb = Request.is_a_repair.size
    @defect_wo_numb = Request.is_a_defect.size
    @tour_car_prep_wo_numb = Request.is_a_tour_car_prep.size
    @defects_outstanding = Vehicle.where(defect: true).size
  end

  def create_work_order
    @other_service = Program.find_by(name: 'Other Service')
    @request = Request.create(status: 'New', program_id: @other_service.id, vehicle_id: params[:id],
                              description: '****** Please fill this in ******', completion_date: Date.current,
                              creator: current_user.name, request_mileage: Vehicle.find(params[:id].mileage))
    if @request.save
      flash[:notice] = 'Work Order Created! Please select Service, Status and enter dates.'
    else
      flash[:alert] = 'Could not create Work Order!'
    end
    redirect_to edit_request_path(id: @request.id)
  end

  def add_to_request_part_order
    part_quant = Part.find(params[:part_id]).quantity
    if part_quant.nil?
      flash[:alert] = 'Quantity of part unkown. Please update quantity in Parts Dashboard and try again.'
    elsif part_quant > 0
      part_item = PartItem.create(part_id: params[:part_id], quantity: params[:quantity], request_id: params[:request_id])
      part_item.update(part_item_total: (part_item.quantity * part_item.part.cost))
      flash[:notice] = 'Part successfully added to cart!'
    else
      flash[:alert] = 'Part Out of Stock!'
    end
    redirect_back(fallback_location: root_path)
  end

  def delete_parts
    part_item = PartItem.find(params[:part_id])
    part_item.destroy
    flash[:notice] = 'Part successfully removed from cart!' if part_item.destroy
    redirect_back(fallback_location: root_path)
  end

  def remove_order_item
    @part_order = RequestPartOrder.find(params[:order_id])
    @part = Part.find(params[:key])
    @part_order.order_total = @part_order.order_total - @part.cost
    new_order_item_hash = @part_order.order_items.reject {|k,v| k == params[:key]}
    @part_order.update(order_items: new_order_item_hash)
    respond_to do |format|
      format.html { redirect_to request_path(params[:request_id]), notice: 'Part was successfully removed!' }
    end
  end

  def add_parts
    @part_items = PartItem.where(request_id: params[:request_id])
    @part_orders = RequestPartOrder.where('request_id = ?', params[:request_id])

    unless @part_items.empty?
      if !@part_orders.empty?
        @part_orders.each do |current_part_order|
          current_part_order.order_items.each do |old_part_id, quantity|
            @part_items.each do |part_item|
              if old_part_id == part_item.part.id
                part_item.part.update(quantity: (part_item.part.quantity - part_item.quantity))
                current_part_order.order_items[old_part_id] = quantity + part_item.quantity
                current_part_order.order_total += part_item.part_item_total
                current_part_order.save       
                part_item.destroy
              end
            end
          end
          @part_items = PartItem.where(request_id: params[:request_id])
          unless @part_items.empty?
            @part_items.each do |part_item|
              part_item.part.update(quantity: (part_item.part.quantity - part_item.quantity))
              current_part_order.order_items[part_item.part_id] = part_item.quantity
              current_part_order.order_total += part_item.part_item_total
              current_part_order.save
              PartRequest.create(part_id: part_item.part_id, request_id: params[:request_id])
            end
          end
        end
        @part_items.destroy_all 
      else
        @part_order = RequestPartOrder.new(user_id: current_user.id, request_id: params[:request_id], order_total: 0)
        @part_items.each do |part_item|
          part_item.part.update(quantity: (part_item.part.quantity - part_item.quantity))
          @part_order.order_items[part_item.part_id] = part_item.quantity
          @part_order.order_total += part_item.part_item_total
        end
        @part_order.save
        unless @part_order.order_items.empty?
          @part_order.order_items.each do |key, value|
            PartRequest.create(part_id: Part.find(key).id, request_id: @part_order.request_id)
          end
        end
        @part_items.destroy_all
      end
      flash[:notice] = 'Parts successfully added to work order!'
    end
    redirect_back(fallback_location: root_path)
  end

  def check_quant
    @part_quant = Part.where('quantity <= ?', 0)
    redirect_back(fallback_location: root_path) if @part_quant.ids == Part.ids
  end

  def new
    @request = Request.new
    if Request.last
      @last_work_order = Request.last.id
    else
      @last_work_order = 0
    end 
  end

  def edit
    if @request.vehicle_id != 'nil'
      @defects = Vehicle.find(@request.vehicle_id).defects.where(fixed: false)
    elsif !@request.multi_vehicle
       @defects = Vehicle.find(@request.vehicles.last.id).defects.where(fixed: false)
    end
    @q = Part.ransack(params[:q])
    @parts = @q.result.page(params[:page])
  end
  
  def edit_multi_vehicle
    @request = Request.find(params[:id])
  end

  def request_email(_request)
    unless @request.defect? && @request.completed?
      if @request.users.exists?
        emails = []
        @request.users.all.each do |user|
          emails << user.email
        end
        UserMailer.assign_request_email(emails, @request).deliver_now
      end
    end
  end

  def decide
  end

  def multi_vehicle
    @request = Request.new
    if Request.last
      @last_work_order = Request.last.id
    else
      @last_work_order = 0
    end
  end
  
  def tour_car_service(request)
    if request.programs.ids.include?(Program.tour_car_prep.id) && request.completed?
      request.vehicles.each do |vehicle|
        vehicle.update(tour_car_prep: false, needs_service: false, vehicle_status: 'In-Service', last_tour_car_prep_mileage: vehicle.mileage)
      end
    end
    if request.programs.ids.include?(Program.tour_car_prep.id)
      request.update(tour_car_prep: true)
    end
  end

  def defect_update(request)
    if request.programs.ids.include?(Program.defect.id) && request.completed?
      request.vehicles.each do |vehicle|
        vehicle.update(defect: false, needs_service: false, vehicle_status: 'In-Service')
      end
    end
    if request.programs.ids.include?(Program.defect.id)
      request.update(defect: true)
    end
  end
  
  def a_service_update(request)
    if request.programs.ids.include?(Program.a_service.id) && request.completed? 
      request.vehicles.each do |vehicle|
        vehicle.update(last_a_service: vehicle.mileage)
      end
    end
    if request.programs.ids.include?(Program.a_service.id)
      request.update(a_service: true)
    end
  end
  
  def shock_service_update(request)
    if request.programs.ids.include?(Program.shock_service.id) && request.completed?
      request.vehicles.each do |vehicle|
        vehicle.update(last_shock_service: vehicle.mileage)
      end
    end
    if request.programs.ids.include?(Program.shock_service.id)
      request.update(shock_service: true)
    end
  end
  
  def air_filter_service_update(request)
    if request.programs.ids.include?(Program.air_filter_service.id) && request.completed?
      request.vehicles.each do |vehicle|
        vehicle.update(last_air_filter_service: vehicle.mileage)
      end
    end
    if request.programs.ids.include?(Program.air_filter_service.id)
      request.update(air_filter_service: true)
    end
  end

  def repairs_update(request)
    if request.programs.ids.include?(Program.repairs.id) && request.completed?
      request.vehicles.each do |vehicle|
        vehicle.update(vehicle_status: "In-Service", repair_needed: false, needs_service: false)
      end
    elsif request.programs.ids.include?(Program.repairs.id) && request.deadline
      request.vehicles.each do |vehicle|
        vehicle.update(vehicle_status: "Out-of-Service", repair_needed: true, needs_service: true)
      end
    end
  end

  def program_ids(request)
    if request.program_ids.empty?
      request.update(program_ids: [6])
    end
  end
  
  def singular_vehicle(request)
    unless request.multi_vehicle
      request.update(vehicle_ids: [request.vehicle_id])
    end
  end

  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        singular_vehicle @request
        request_email @request
        program_ids @request
        a_service_update @request
        shock_service_update @request
        air_filter_service_update @request
        repairs_update @request
        tour_car_service @request
        defect_update @request
        format.html { redirect_to @request, notice: 'Work Order was successfully created.' }
      else
        if !@request.multi_vehicle
          format.html { render :new }
        else
          format.html {render :multi_vehicle }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @request.update(request_params)
        if @request.users.exists? && @request.status == 'New'
          emails = []
          @request.users.all.each do |user|
            emails << user.email
          end
          UserMailer.assign_request_email(emails, @request).deliver_now
        end

        if @request.users.exists? && @request.status == 'Completed'
          email = User.find_by(name: @request.creator).email
          UserMailer.completed_work_order_email(email, @request).deliver_now
        end

        if @request.status == 'Overdue'
          email = User.find_by(name: @request.creator).email
          UserMailer.overdue_work_order_email(email, @request).deliver_now
        end
        a_service_update @request
        shock_service_update @request
        air_filter_service_update @request
        repairs_update @request
        tour_car_service @request
        defect_update @request
        format.html { redirect_to @request, notice: 'Work Order was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Work Order was successfully destroyed.' }
    end
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end

  def set_vehicle
    @vehicles = Vehicle.all
  end

  def request_params
    params.require(:request).permit(:number, :description, :special_requets, :completion_date,
                                    :completed_date, :poc, :checklist_numb, :creator, :vehicle_id,
                                    :status, :image, :creator, :request_mileage, :mechanic, :deadline,
                                    :mechanic_id, :notes, :times_completed, :multi_vehicle, part_ids: [], 
                                    user_ids: [], defect_ids: [], program_ids: [], vehicle_ids: [])
  end
end
