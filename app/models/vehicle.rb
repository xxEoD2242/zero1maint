class Vehicle < ApplicationRecord
  has_many :events_vehicles
  has_many :events, through: :events_vehicles
  
  
  has_many :requests
  has_many :programs, through: :requests
  
 
  belongs_to :vehicle_category
  belongs_to :location
  
  paginates_per 7
  
  accepts_nested_attributes_for :events
  
  STATUSES = ['In-Service', 'Out-of-Service', 'Sold']
  CATEGORIES = ['RZR', 'Fleet Vehicle', 'Tour Car', 'Dirt Bike', 'Training Vehicle', 'Other']
  
  def self.to_csv(options = {})
      CSV.generate do |csv|
        csv << column_names
        all.each do |vehicle|
          csv << vehicle.attributes.values_at(*column_names)
        end
      end
    end
 
end
