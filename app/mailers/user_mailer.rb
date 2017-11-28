class UserMailer < ApplicationMailer
  default from: 'tts110117@gmail.com'
  
  
  def new_request_email(user, request)
    @request = request
    mail(to: user.email, subject: "Defect Work Order has been created!" )
  end 
  
  def weekly_rzr_report_email(user)
    @rzr = VehicleCategory.find_by(name: "RZR")
    @out_of_service = Vehicle.where(vehicle_category_id: @rzr.id, vehicle_status: "Out-of-Service")
    @vehicles = Vehicle.where(vehicle_category_id: @rzr.id, vehicle_status: "In-Service")   
      @requests = Request.all 
      @set_a_service = Program.find_by(name: "A-Service") 
      @set_shock_service = Program.find_by(name: "Shock Service")
      @set_air_filter_service = Program.find_by(name: "Air Filter Change")
      @set_repairs = Program.find_by(name: "Repairs")  
      @set_defects = Program.find_by(name: "Defect")
      @tracks = Tracker.all   
      @set_new = Tracker.find_by(track: "New")  
      @set_progress = Tracker.find_by(track: "In-Progress")
      @set_completed = Tracker.find_by(track: "Completed")
      @set_overdue = Tracker.find_by(track: "Overdue")
    mail(to: user.email, subject: "Weekly Razor Report")
  end
end
