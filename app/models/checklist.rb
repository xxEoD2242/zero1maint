# frozen_string_literal: true

class Checklist < ApplicationRecord
  before_save :set_fuel_level, :set_date, :set_wash, :set_suspension, :set_drive_train, :set_body, :set_engine, :set_brake, :set_safety_equipment, :set_chassis, :set_electrcial, :set_cooling_system, :set_tires, :set_radio, :set_exhaust, :set_steering

  belongs_to :vehicle
  belongs_to :user
  belongs_to :event
  

  FUEL_LEVELS = ['Full', '3/4', '1/2', '1/4', 'None'].freeze

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

  def set_brake
    self.brake = 'Checked' if brake.blank?
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
end
