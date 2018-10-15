# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'tts110117@gmail.com'

  def new_service_request_email(service)
    @program = service

    mail(to: 'tyler.fedrizzi@gmail.com', subject: 'New Service Requested. Please view.')
  end

  def daily_events_report_email
    @events = Event.where(date: Time.now - 24.hours)
    mail(to: ['ryan@zero1.vegas', 'rick@zero1.vegas'], subject: 'Daily Events Report')
  end

  def update_service_email(service)
    @program = service

    mail(to: 'tyler.fedrizzi@gmail.com', subject: 'Update Service Requested. Please view.')
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
     User.where(subscribe: true).each do |user|
      emails << user.email
    end
    @completed = Events.where(event_status: 'Completed')
    mail(to: emails, subject: "Weekly Event Report for #{Time.now.strftime('%D')}")
  end

  def weekly_event_checklists_email
    emails = []
    User.where(subscribe: true).each do |user|
      emails << user.email
    end
    @eve = Event.where('date >= ?', Time.now - 7.days)
    @now = @eve.where('date <= ?', Time.now)
    @events = @now.all

    mail(to: emails, subject: "Weekly Checklists for Events From #{(Time.now - 7.days).strftime('%D')} To #{Time.now.strftime('%D')}")
  end

  def weekly_rzr_report_email
    emails = []
    User.where(subscribe: true).each do |user|
      emails << user.email
    end
    @out_of_service = Vehicle.are_rzr.out_of_service?
    @in_service = Vehicle.are_rzr.in_service?
    mail(to: emails, subject: "Weekly Razor Report for #{Date.current.strftime('%D')}")
  end
  
  def weekly_tour_car_report
    emails = []
    User.where(subscribe: true).each do |user|
      emails << user.email
    end
    @out_of_service = Vehicle.are_tour_cars.out_of_service?
    @in_service = Vehicle.are_tour_cars.in_service?
    mail(to: emails, subject: "Weekly Tour Car Report for #{Date.current.strftime('%D')}")
  end
  
  def weekly_other_vehicles_report
    emails = []
    User.where(subscribe: true).each do |user|
      emails << user.email
    end
    @out_of_service = Vehicle.where('veh_category != ? AND veh_category != ?', 'RZR', 'Tour Car').out_of_service?
    @in_service = Vehicle.where('veh_category != ? AND veh_category != ?', 'RZR', 'Tour Car').in_service?
    mail(to: emails, subject: "Weekly Other Vehicles Report for #{Time.now.strftime('%D')}")
  end

  def weekly_defects_report_email
    emails = []
    User.where(subscribe: true).each do |user|
      emails << user.email
    end
    @set_defects = Program.find_by(name: 'Defect')
    @new_work_orders = Request.is_a_defect.one_week?.is_new
    @in_progress_work_orders = Request.is_a_defect.one_week?.is_in_progress
    @completed_work_orders = Request.is_a_defect.one_week?.is_completed
    @overdue_work_orders = Request.is_a_defect.one_week?.is_overdue
    mail(to: emails, subject: "Weekly Defect Work Order Report for #{Date.current.strftime('%D')}")
  end
  
  def weekly_repairs_report
    emails = []
     User.where(subscribe: true).each do |user|
      emails << user.email
    end
    @set_repairs = Program.find_by(name: 'Repairs')
    @new_work_orders = Request.is_a_repair.one_week?.is_new
    @in_progress_work_orders = Request.is_a_repair.one_week?.is_in_progress
    @completed_work_orders = Request.is_a_repair.one_week?.is_completed
    @overdue_work_orders = Request.is_a_repair.one_week?.is_overdue
    mail(to: emails, subject: "Weekly Defect Work Order Report for #{Date.current.strftime('%D')}")
  end

  def weekly_work_order_report_email
    emails = []
    User.where(subscribe: true).each do |user|
      emails << user.email
    end

    @set_a_service = Program.find_by(name: 'A-Service')
    @set_shock_service = Program.find_by(name: 'Shock Service')
    @set_air_filter_service = Program.find_by(name: 'Air Filter Change')
    @set_repairs = Program.find_by(name: 'Repairs')
    @set_defects = Program.find_by(name: 'Defect')
    @requests = Request.where('created_at > ? AND program_id != ?', 1.month.ago, @set_defects.id)
    @new = @requests.is_new
    @in_progress = @requests.is_in_progress
    @completed = @requests.is_completed
    @overdue = @requests.is_overdue
    mail(to: emails, subject: "Weekly Work Order Report for #{Date.current.strftime('%D')}")
  end
  
  def weekly_defects_reported
    emails = []
    User.where(subscribe: true).each do |user|
      emails << user.email
    end
    
    @defects = Defect.all.where('created_at > ? AND created_at <= ?', (Date.current - 7.days), Date.current)
    mail(to: emails, subject: "Weekly Defects that have been reported for #{Date.current.strftime('%D')}")
  end

  def weekly_defects_outstanding
    emails = []
    User.where(subscribe: true).each do |user|
      emails << user.email
    end
    
   @vehicles = Vehicle.where(defect: true)
    
    mail(to: emails, subject: "Vehicles that have defects reported for #{Date.current.strftime('%D')}")
  end
end
