class Event < ApplicationRecord
  before_save :set_customers, :set_shares, :set_est_mileage
  
  
  has_many :checklists
  
  has_many :events_vehicles
  has_many :vehicles, through: :events_vehicles
  
  validates :vehicles, presence: true, on: :update
  
  has_many :event_reports
  has_many :reports, through: :event_reports
  
  validates :status, presence: true
  validates :event_type, presence: true
  validates :class_type, presence: true
  validates :est_mileage, presence: true
  
  
  paginates_per 5
  
  accepts_nested_attributes_for :vehicles
  
  STATUSES = ['Scheduled', 'Vehicles Assigned', 'In-Progress', 'Completed', 'Cancelled']
  EVENT_TYPES = ['Odyssey', 'RZR', 'Military Training', 'Race Event', 'Filming', 'Special Event', 'Training Non-NSW', 'Demonstration']
  CLASS_TYPES = ['Road Runner', 'Mojave','Pioneer','Sundown', '2 Day Odyssey', '3 Day Odyssey', '4 Day Odyssey', 'Special Event', 'Training', 'Race']
  LOCATION = ['RZR Base Camp', 'The Ranch', 'Speedway', 'Uvalde', 'Other']
  DURATION_WORDS = ['Minutes', 'Hours', 'Days', 'Weeks']
  
  
  def set_est_mileage
      self.est_mileage = 0 if self.est_mileage.blank?
    end
  
  def set_customers
      self.customers = 0 if self.customers.blank?
  end
      
      
  def set_shares
      self.shares = 0 if self.shares.blank?
  end
  
end
