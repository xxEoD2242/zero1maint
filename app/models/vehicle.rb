class Vehicle < ApplicationRecord
  require 'csv'
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
    
    def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
        Vehicle.create! row.to_hash
      end
    end
 
end
