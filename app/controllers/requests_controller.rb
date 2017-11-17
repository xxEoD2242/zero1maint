class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :set_vehicle, :set_tracker, only: [:index, :show, :edit, :new]
  before_action :set_services, only: [:show, :index, :new, :edit]
  before_action :a_service, :shock_service, :air_filter_service, :repairs, only: [:dashboard]
  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all.page(params[:page])
    @q = Request.ransack(params[:q])
    @request_results = @q.result.includes(:vehicle).page(params[:page])
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end
  
  def a_service
    @a_service = Request.where(program_id: 8, tracker_id: 1)
    @q = Request.where(program_id: 8, tracker_id: 1).ransack(params[:q])
    @request_results = @q.result.includes(:vehicles).page(params[:page])
  end
  
  def shock_service
    @shock_service = Request.where(program_id: 9, tracker_id: 1)
    @q = Request.where(program_id: 9, tracker_id: 1).ransack(params[:q])
    @request_results = @q.result.includes(:vehicles).page(params[:page])
  end
  
  def air_filter_service
    @air_filter_service = Request.where(program_id: 7, tracker_id: 1)
    @q = Request.where(program_id: 7, tracker_id: 1).ransack(params[:q])
    @request_results = @q.result.includes(:vehicles).page(params[:page])
  end
  
  def repairs
    @repairs = Request.where(program_id: 10, tracker_id: 1)
    @q = Request.where(program_id: 10, tracker_id: 1).ransack(params[:q])
    @request_results = @q.result.includes(:vehicles).page(params[:page])
  end
  
  def dashboard
    @requests = Request.all
    
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
    @requests = Request.find_by(params[:number])
  
  end

  # POST /requests
  # POST /requests.json
  def create
    @request = Request.new(request_params)
    
    respond_to do |format|
      
      if @request.save
        veh_mileage = @request.vehicle.mileage
        vehicle = @request.vehicle
        @request.update(request_mileage: (veh_mileage))
        if @request.program_id == 10 && @request.tracker_id == 1
                  vehicle.update(repair_needed: true, vehicle_status: "Out-of-Service")
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
    respond_to do |format|
      if @request.update(request_params)
        vehicle = @request.vehicle
        if @request.program_id == 10 && @request.tracker_id == 3
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
    
    def set_tracker
      @tracks = Tracker.all
    end
    
    def set_services
      @programs = Program.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:number, :description, :special_requets, :completion_date, :poc, :vehicle_id, :tracker_id, :image, :user_id, :request_mileage, :program_id)
    end
end
