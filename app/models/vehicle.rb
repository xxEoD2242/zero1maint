class Vehicle < ApplicationRecord
  has_many :events_vehicles
  has_many :events, through: :events_vehicles
 
  belongs_to :vehicle_category
  has_many :requests
  belongs_to :location
  
  accepts_nested_attributes_for :events
  
  STATUSES = ['In-Service', 'Out-of-Service', 'Sold']
end
