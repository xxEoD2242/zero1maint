class Part < ApplicationRecord
  require 'csv'
  attr_accessor :custom_field
  
  has_many :part_requests
  has_many :requests, through: :part_requests
  
  has_many :part_reports
  has_many :reports, through: :part_reports
  
  belongs_to :vehicle_category
  has_many :part_items
  
  validates :part_numb, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :quantity, presence: true 
  validates :quantity, numericality: {greater_than: 0, message: "must have a quantity greater than 0"}
  validates :cost, presence: true
  validates :cost, numericality: {greater_than: 0, message: "must have a cost. If no cost is associated, put 0.01!"}
  
  paginates_per 7
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Part.create! row.to_hash
    end
  end
  CATEGORIES = ['Body', 'Brakes', 'Chassis', 'Cooling System', 'Driveline', 'Engine', 'Electrical', 'Steering', 'Radio-Communication', 'Wheel-Tires', 'Exhaust']
end
