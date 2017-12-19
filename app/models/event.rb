class Event < ApplicationRecord
  
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
  
  def set_est_mileage
      self.est_mileage = 0 if self.est_mileage.blank?
    end
  
end
