# frozen_string_literal: true

class Vehicle < ApplicationRecord
  before_save :set_last_a_service, :set_last_shock_service, :set_last_air_filter_service
  validates_uniqueness_of :car_id

  require 'csv'
  has_many :events_vehicles
  has_many :events, through: :events_vehicles

  has_many :requests, inverse_of: :vehicle
  has_many :programs, through: :requests

  has_many :report_vehicles
  has_many :reports, through: :report_vehicles

  has_many :checklists

  validates :car_id, presence: true
  validates :vehicle_status, presence: true
  validates :mileage, presence: true
  validates :location, presence: true

  paginates_per 8

  accepts_nested_attributes_for :events

  STATUSES = ['In-Service', 'Out-of-Service', 'Sold'].freeze
  CATEGORIES = ['RZR', 'Fleet Vehicle', 'Tour Car', 'Dirt Bike', 'Training Vehicle', 'Other'].freeze
  LOCATION = ['RZR Base Camp', 'The Ranch', 'Speedway', 'Uvalde', 'Other'].freeze

  def vehicle_naming
    "&nbsp; #{car_id} &nbsp;".html_safe
  end

  def self.to_csv(_options = {})
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

  def set_last_a_service
    self.last_a_service = 0 if last_a_service.blank?
  end

  def set_last_shock_service
    self.last_shock_service = 0 if last_shock_service.blank?
  end

  def set_last_air_filter_service
    self.last_air_filter_service = 0 if last_air_filter_service.blank?
  end

  def set_times_used
    self.times_used = 0 if times_used.blank?
  end
end
