# frozen_string_literal: true

class Part < ApplicationRecord
  require 'csv'
  attr_accessor :custom_field

  has_many :part_requests
  has_many :requests, through: :part_requests

  has_many :part_reports
  has_many :reports, through: :part_reports

  has_many :part_items

  validates :part_numb, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0, message: 'must have a quantity greater than 0' }, on: :create
  validates :cost, presence: true
  validates :cost, numericality: { greater_than: 0, message: 'must have a cost. If no cost is associated, put 0.01!' }
  
  mount_uploader :image, ImageUploader

  paginates_per 15
  
  # Write code to update quantity/location/category if the part is already in the system.
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      row_hash = row.to_hash
      if old_part = Part.find_by(part_numb: row_hash["part_numb"])
        old_part.update(description: row_hash["description"], quantity: row_hash["quantity"], category: row_hash["category"], location: row_hash["location"], cost: row_hash["cost"], vehicle_category: row_hash["vehicle_category"], quant_none: false, brand: row_hash["brand"])
      else
       Part.create! row_hash
    end
    end
  end
  CATEGORIES = ['Body', 'Brakes', 'Chassis', 'Cooling System', 'Driveline', 'Engine', 'Electrical', 'Steering', 'Radio-Communication', 'Wheel-Tires', 'Exhaust'].freeze

  VEHICLE_CATEGORIES = ['RZR', 'Fleet Vehicle', 'Tour Car', 'Dirt Bike', 'Training Vehicle', 'Other'].freeze
  
  LOCATION = ['RZR Basecamp', 'The Ranch', 'Speedway', 'Uvalde', 'Other '].freeze
end
