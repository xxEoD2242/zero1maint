class Vehicle < ApplicationRecord
  has_many :events_vehicles
  has_many :events, through: :events_vehicles
  
  
  has_many :requests
  has_many :programs, through: :requests
  
 
  belongs_to :vehicle_category
  belongs_to :location
  
  paginates_per 5
  
  accepts_nested_attributes_for :events
  
  STATUSES = ['In-Service', 'Out-of-Service', 'Sold']
end
