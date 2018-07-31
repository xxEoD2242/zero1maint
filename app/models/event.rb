# frozen_string_literal: true

class Event < ApplicationRecord
  before_save :set_customers, :set_shares, :set_est_mileage

  has_many :checklists

  has_many :events_vehicles
  has_many :vehicles, through: :events_vehicles

  has_many :event_reports
  has_many :reports, through: :event_reports

  validates :status, presence: true
  validates :event_type, presence: true
  validates :class_type, presence: true
  validates :est_mileage, presence: true

  paginates_per 10

  accepts_nested_attributes_for :vehicles

  STATUSES = ['Scheduled', 'Vehicles Assigned', 'In-Progress', 'Completed', 'Cancelled'].freeze
  EVENT_TYPES = ['Odyssey', 'RZR', 'Military Training', 'Race Event', 'Filming', 'Special Event', 'Training Non-NSW', 'Demonstration'].freeze
  CLASS_TYPES = ['Road Runner', 'Mojave', 'Pioneer', 'Sundown', '2 Day Odyssey', '3 Day Odyssey', '4 Day Odyssey', 'Special Event', 'Training', 'Race'].freeze
  LOCATION = ['RZR Base Camp', 'The Ranch', 'Speedway', 'Uvalde', 'Other'].freeze
  LOCATIONS = ['RZR Base Camp', 'The Ranch', 'Speedway'].freeze
  DURATION_WORDS = %w[Minutes Hours Days Weeks].freeze

  def set_est_mileage
    self.est_mileage = 0 if est_mileage.blank?
    end

  def set_customers
    self.customers = 0 if customers.blank?
  end

  def set_shares
    self.shares = 0 if shares.blank?
  end
  
  def checklists_completed
    self.checklists_completed = true if self.checklists.exists? && self.vehicles.count == Checklist.where(event_id: self.id, completed: true).count
  end
  
  def is_completed?
    status == 'Completed'
  end
  
  def is_scheduled?
    status == 'Scheduled'
  end
  
  def is_vehicles_assigned?
    status == 'Vehicles Assigned'
  end
  
  def is_cancelled?
    status == 'Cancelled'
  end
  
  def is_in_progress?
    status == 'In-Progress'
  end
end
