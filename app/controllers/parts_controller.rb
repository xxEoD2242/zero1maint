class PartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_requests, only: [:dashboard]
  before_action :set_part, only: [:show, :edit, :update, :destroy]
  before_action :quant_calculation, only: [:quant_none, :quant_low, :show, :dashboard]
  before_action :set_vehicle_category, only: [:new, :edit]
  
  # GET /parts
  # GET /parts.json
  def index
    @parts = Part.all.order(:created_at)
    @q = Part.order(:created_at).ransack(params[:q])
    @part_results = @q.result.page(params[:page])
  end
  
  def import
    Part.import(params[:file])
    redirect_to root_url, notice: "Activity Data Imported!"
  end
  
  def financial_report
    @requests = Request.all
    
    total_cost = []
     Part.all.each do |part|
       if part.quantity != nil
         if part.cost != nil
     cost = (part.quantity * part.cost)
     total_cost << cost
   end
 end
   end
   @inventory_value = total_cost.sum
   respond_to do |format|
        format.html
        format.xls
        format.pdf do
          render pdf: "Financial Report for #{Time.now.strftime('%D')}", :layout => 'pdf.pdf.erb'  # Excluding ".pdf" extension.
        end
      end
  end
  
  def quant_calculation
    @parts = Part.all
    @parts.each do |part|
      if part.quantity != nil
      if part.quantity <= 0 
        part.update(quant_none: true)
      elsif part.quantity <= 3 && part.quantity > 0
        part.update(quant_low: true)
      else
        part.update(quant_low: false, quant_none: false)
      end
    end
  end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end
  
  def dashboard
    @parts = Part.all
  end
  
  def quant_none
    @q = Part.where(quant_none: true).order(:created_at).ransack(params[:q])
    @part_results = @q.result.page(params[:page])
  end
  
  def quant_low
    @q = Part.where(quant_low: true).order(:created_at).ransack(params[:q])
    @part_results = @q.result.page(params[:page])
  end
  
  # GET /events/new
  def new
    @part = Part.new
    @vehicles = Vehicle.all
    
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @part = Part.new(part_params)
    respond_to do |format|
      if @part.save
        format.html { redirect_to @part, notice: 'Part was successfully created.' }
        format.json { render :show, status: :created, location: @part }
      else
        format.html { render :new }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @part.update(part_params)
        format.html { redirect_to @part, notice: 'Part was successfully updated.' }
        format.json { render :show, status: :ok, location: @part }
      else
        format.html { render :edit }
        format.json { render json: @part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @part.destroy
    respond_to do |format|
      format.html { redirect_to parts_url, notice: 'Part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part
      @part = Part.find(params[:id])
    end
    
    def set_location
      @location = Location.all
    end
    
    def set_vehicle_category
      @vehicle_category = VehicleCategory.all
    end
    
    def set_requests
      @requests = Request.all
    end

    def part_params
      params.require(:part).permit(:part_numb, :description, :brand, :category, :vehicle_category_id, :cost, :quantity)
    end
end

