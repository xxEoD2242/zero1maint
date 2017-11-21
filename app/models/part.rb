class Part < ApplicationRecord
  attr_accessor :custom_field
  
  has_many :part_requests
  has_many :requests, through: :part_requests
  
  belongs_to :vehicle_category
  has_many :part_items
  CATEGORIES = ['Body', 'Brakes', 'Chassis', 'Cooling System', 'Driveline', 'Engine', 'Electrical', 'Steering', 'Radio-Communication', 'Wheel-Tires', 'Exhaust']
end
