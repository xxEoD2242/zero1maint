class UserMailer < ApplicationMailer
  default from: 'tts110117@gmail.com'
  
  def new_service_request_email(service)
    @program = service
    
    mail(to: "tyler.fedrizzi@gmail.com", subject: "New Service Requested. Please view.")
  end
  
  def update_service_email(service)
    @program = service
    
    mail(to: "tyler.fedrizzi@gmail.com", subject: "Update Service Requested. Please view.")
  end
  
  def overdue_work_order_email(email, work_order)
    @request = work_order
    
    mail(to: email, subject: "Work Order #{@request.id} is overdue. Please view.")
  end
  
  def completed_work_order_email(email, request)
    @request = request
    
    mail(to: email, subject: "Work Order #{@request.id} has been completed. Please view.")
  end
  
  def new_request_email(emails, request)
    @request = request
    
    mail(to: emails, subject: "Work Order #{@request.id} has been created and assigned. Please view.")
  end
  
  def assign_request_email(emails, request)
    @request = request
    
    mail(to: emails, subject: "Work Order #{@request.id} has been created and assigned. Please view.")
  end
  
  def weekly_events_report
    emails = []
    User.all.each do |user|
      emails << user.email
    end
    @completed = Events.where(event_status: "Completed")
    mail(to: emails, subject: "Weekly Event Report for #{Time.now.strftime('%D')}")
  end 
  
  def weekly_new_progress_report_email
    emails = []
    User.all.each do |user|
      emails << user.email
    end
    @set_new = Tracker.find_by(track: "New")  
    @set_progress = Tracker.find_by(track: "In-Progress")
    @requests = Request.where('created_at > ?', 1.month.ago)
    @new = @requests.where(tracker_id: @set_new.id)
    @in_progress = @requests.where(tracker_id: @set_progress.id)
    mail(to: emails, subject: "Weekly New & In-Progress Work Orders Report for #{Time.now.strftime('%D')}")
  end
  
  def weekly_event_checklists_email
    emails = []
    User.all.each do |user|
      emails << user.email
    end
    
    @eve = Event.where('date >= ?', Time.now - 7.days)
    @now = @eve.where('date <= ?', Time.now)
    @events = @now.all
    
    mail(to: emails, subject: "Weekly Checklists for Events From #{(Time.now - 7.days).strftime('%D')} To #{Time.now.strftime('%D')}")
  end
  
  def weekly_rzr_report_email
    emails = []
    User.all.each do |user|
      emails << user.email
    end
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
    mail(to: emails, subject: "Weekly Razor Report for #{Time.now.strftime('%D')}")
  end
  
  def weekly_defects_report_email
    emails = []
    User.all.each do |user|
      emails << user.email
    end
    @set_new = Tracker.find_by(track: "New")
    @set_progress = Tracker.find_by(track: "In-Progress")
    @set_defects = Program.find_by(name: "Defect")
    @request = Request.where(program_id: @set_defects.id, tracker_id: @set_new.id)
    @in_progress = Request.where(program_id: @set_defects.id, tracker_id: @set_progress.id)
    
    mail(to: emails, subject: "Weekly Defect Work Order Report for #{Time.now.strftime('%D')}")
  end
  
  def weekly_work_order_report_email
    emails = []
    User.all.each do |user|
      emails << user.email
    end
    
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
    @requests = Request.where('created_at > ?', 1.month.ago)
    @new = @requests.where(tracker_id: @set_new.id)
    @in_progress = @requests.where(tracker_id: @set_progress.id)
    @completed = @requests.where(tracker_id: @set_completed.id)
    @overdue = @requests.where(tracker_id: @set_overdue.id)
    mail(to: emails, subject: "Weekly Work Order Report")
  end
end

