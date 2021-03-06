# frozen_string_literal: true

class Vehicle < ApplicationRecord
  before_save :set_last_a_service, :set_last_shock_service, :set_last_air_filter_service
  after_save :set_thresholds
  validates_uniqueness_of :car_id

  require 'csv'
  has_many :events_vehicles
  has_many :events, through: :events_vehicles

  has_many :request_vehicles
  has_many :requests, through: :request_vehicles
  
  has_many :programs, through: :requests

  has_many :report_vehicles
  has_many :reports, through: :report_vehicles

  has_many :checklists
  has_many :defects

  validates :car_id, presence: true
  validates :vehicle_status, presence: true
  validates :mileage, presence: true
  validates :location, presence: true

  paginates_per 10

  accepts_nested_attributes_for :events

  scope :in_service?, -> { where(vehicle_status: 'In-Service') }
  scope :out_of_service?, -> { where(vehicle_status: 'Out-of-Service') }
  scope :sold?, -> { where(vehicle_status: 'Sold') }
  scope :are_rzr, -> { where(veh_category: 'RZR') }
  scope :are_tour_cars, -> { where(veh_category: 'Tour Car') }

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

  def set_thresholds
    if veh_category == 'RZR'
      self.a_service_interval = Program.a_service.rzr_interval
      self.shock_service_interval = Program.shock_service.rzr_interval
      self.air_filter_service_interval = Program.air_filter_service.rzr_interval
    elsif veh_category == 'Fleet Vehicle'
      self.a_service_interval = Program.a_service.fleet_interval
      self.shock_service_interval = Program.shock_service.fleet_interval
      self.air_filter_service_interval = Program.air_filter_service.fleet_interval
    elsif veh_category == 'Tour Car'
      self.a_service_interval = Program.a_service.tour_car_interval
      self.shock_service_interval = Program.shock_service.tour_car_interval
      self.air_filter_service_interval = Program.air_filter_service.tour_car_interval
      self.tour_car_prep_interval = Program.tour_car_prep.tour_car_interval
    elsif veh_category == 'Dirt Bike'
      self.a_service_interval = Program.a_service.db_interval
      self.shock_service_interval = Program.shock_service.db_interval
      self.air_filter_service_interval = Program.air_filter_service.db_interval
    elsif veh_category == 'Training Vehicle'
      self.a_service_interval = Program.a_service.training_interval
      self.shock_service_interval = Program.shock_service.training_interval
      self.air_filter_service_interval = Program.air_filter_service.training_interval
    elsif veh_category == 'Other'
      self.a_service_interval = Program.a_service.other_interval
      self.shock_service_interval = Program.shock_service.other_interval
      self.air_filter_service_interval = Program.air_filter_service.other_interval
    end
  end
  
  def is_in_service?
    vehicle_status == 'In-Service'
  end
  
  def is_out_of_service?
    vehicle_status == 'Out-of-Service'
  end
  
  def tour_car?
    veh_category == 'Tour Car'
  end
end
