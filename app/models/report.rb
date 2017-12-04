class Report < ApplicationRecord
  
  
  has_many :report_users
  has_many :users, through: :report_users
  
  has_many :request_reports
  has_many :requests, through: :request_reports
  
  has_many :report_vehicles
  has_many :vehicles, through: :report_vehicles
  
  has_many :event_reports
  has_many :events, through: :event_reports
  
  has_many :part_reports
  has_many :parts, through: :part_reports
  
  has_many :report_vehicle_orders
  
  paginates_per 5
  
  mount_uploader :report_doc, ReportDocUploader
  
  
  STATUSES = ['Created', 'Viewed', 'Filed']
  TYPES = ['Weekly', 'Weekly-RZR', 'Monthly', 'Vehicle', 'Event', 'Work Order', 'Part', 'Financial', 'Labor']
  
  
end
