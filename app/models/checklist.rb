# frozen_string_literal: true

class Checklist < ApplicationRecord
  before_create :set_fuel_level, :set_date, :set_wash,
              :set_suspension, :set_drive_train, :set_body,
              :set_engine, :set_brakes, :set_safety_equipment,
              :set_chassis, :set_electrcial, :set_cooling_system,
              :set_tires, :set_radio, :set_exhaust, :set_steering,
              :defects_detected, :completed, :has_defects?
  belongs_to :vehicle
  belongs_to :user
  belongs_to :event
  
  has_many :checklist_defects
  has_many :defects, through: :checklist_defects
  
  validates :checklist_type, presence: true
  
  scope :completed?, -> { where(defect: true) }
  scope :have_defects?, -> { where(defect: true) }

  FUEL_LEVELS = ['Full', '3/4', '1/2', '1/4', 'None'].freeze
  
  TYPES = ['Pre-Event', 'Post-Event'].freeze

  def set_date
    self.date = Time.current if date.blank?
  end

  def set_fuel_level
    self.fuel_level = 'Checked' if fuel_level.blank?
    end

  def set_wash
    self.wash = 'Checked' if wash.blank?
    end

  def set_suspension
    self.suspension = 'Checked' if suspension.blank?
    end

  def set_drive_train
    self.drive_train = 'Checked' if drive_train.blank?
    end

  def set_body
    self.body = 'Checked' if body.blank?
    end

  def set_brakes
    self.brakes = 'Checked' if brakes.blank?
    end

  def set_safety_equipment
    self.safety_equipment = 'Checked' if safety_equipment.blank?
    end

  def set_electrcial
    self.electrical = 'Checked' if electrical.blank?
    end

  def set_cooling_system
    self.cooling_system = 'Checked' if cooling_system.blank?
    end

  def set_exhaust
    self.exhaust = 'Checked' if exhaust.blank?
    end

  def set_steering
    self.steering = 'Checked' if steering.blank?
    end

  def set_engine
    self.engine = 'Checked' if engine.blank?
  end

  def set_chassis
    self.chassis = 'Checked' if chassis.blank?
  end

  def set_radio
    self.radio = 'Checked' if radio.blank?
  end

  def set_tires
    self.tires = 'Checked' if tires.blank?
  end

  def completed
    self.completed = true
  end

  def defects_detected
    maintenance = %w[engine suspension steering tires
                     radio chassis exhaust cooling_system
                     electrical safety_equipment brakes body
                     drive_train suspension]
    attributes.each do |k, v|
      self.defect = true if v != 'Checked' && maintenance.include?(k)
    end
  end

  def has_defects?
    self.defect = true if !self.defect_ids.empty?
  end
end
