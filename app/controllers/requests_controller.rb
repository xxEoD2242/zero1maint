# frozen_string_literal: true

class RequestsController < ApplicationController
  before_action :set_request, only: %i[show edit update destroy]
  before_action :set_vehicle, only: %i[index show edit new]
  before_action :check_quant, only: [:show]

  def index
    @requests = Request.all.page(params[:page])
    @q = Request.ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def overdue
    @q = Request.where(status: 'Overdue').ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def completed
    @q = Request.where(status: 'Completed').ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def new_requests
    @q = Request.where(status: 'New').ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def in_progress
    @q = Request.where(status: 'In-Progress').ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def show
    @number = Part.count
    @part_items = PartItem.where(request_id: @request.id)
    @q = Part.ransack(params[:q])
    @parts = @q.result
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
    @a_service_requests = Request.is_an_a_service
    @q = Request.is_an_a_service.ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def shock_service
    @shock_service = Program.shock_service
    @shock_service_requests = Request.where(program_id: @shock_service.id)
    @q = Request.where(program_id: @shock_service.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def air_filter_service
    @air_filter_service = Program.find_by(name: 'Air Filter Change')
    @air_filter_requests = Request.where(program_id: @air_filter_service.id)
    @q = Request.where(program_id: @air_filter_service).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def repairs
    @repairs = Program.find_by(name: 'Repairs')
    @repair_requests = Request.where(program_id: @repairs.id)
    @q = Request.where(program_id: @repairs.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def defects
    @defects = Program.find_by(name: 'Defect')
    @defect_requests = Request.where(program_id: @defects.id)
    @q = Request.where(program_id: @defects.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  def tour_car_prep
    @tour_car_prep = Program.find_by(name: 'Tour Car Prep')
    @tour_car_prep_requests = Request.where(program_id: @tour_car_prep.id)
    @q = Request.where(program_id: @tour_car_prep.id).ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
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
    part_item = PartItem.find(params[:id])
    part_item.destroy
    flash[:notice] = 'Part successfully removed from cart!' if part_item.destroy
    redirect_back(fallback_location: root_path)
  end

  def remove_parts_from_request
    @part_orders = RequestPartOrder.where(request_id: params[:request_id])
    @part_orders.each do |part_order|
      part_order.destroy if part_order.order_items.key?(params[:key])
    end
    redirect_back(fallback_location: root_path)
  end

  def add_parts
    part_items = PartItem.where(request_id: params[:request_id])
    unless part_items.empty?
      @part_order = RequestPartOrder.new(user_id: current_user.id, request_id: params[:request_id], order_total: 0)
      part_items.each do |part_item|
        part_item.part.update(quantity: (part_item.part.quantity - part_item.quantity))
        @part_order.order_items[part_item.part_id] = part_item.quantity
        @part_order.order_total += part_item.part_item_total
      end
      @part_order.save
      @part_order.order_items.each do |key, _value|
        PartRequest.create(part_id: Part.find(key).id, request_id: @part_order.request_id)
      end
      part_items.destroy_all
    end
    unless @part_order.nil?
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
  end

  def edit
    @defects = Vehicle.find(@request.vehicle.id).defects.where(fixed: false)
    @q = Part.ransack(params[:q])
    @parts = @q.result.page(params[:page])
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

  def create
    @request = Request.new(request_params)

    respond_to do |format|
      if @request.save
        vehicle = @request.vehicle
        @request.update(request_mileage: vehicle.mileage)
        request_email @request
        format.html { redirect_to @request, notice: 'Work Order was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @repairs = Program.find_by(name: 'Repairs')
    @a_service = Program.a_service
    @shock_service = Program.shock_service
    @air_filter_service = Program.air_filter_service
    @tour_car_prep = Program.tour_car_prep
    @repairs = Program.repairs
    @defects = Program.defect
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

        format.html { redirect_to @request, notice: 'Work Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Work Order was successfully destroyed.' }
      format.json { head :no_content }
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
                                    :status, :image, :creator, :request_mileage, :program_id, :mechanic,
                                    :mechanic_id, :notes, :times_completed, part_ids: [], user_ids: [], defect_ids: [])
  end
end
