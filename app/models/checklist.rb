class Checklist < ApplicationRecord
  before_save :set_fuel_level, :set_wash, :set_suspension, :set_drive_train, :set_body, :set_engine, :set_brake, :set_safety_equipment, :set_chassis, :set_electrcial, :set_cooling_system, :set_tires, :set_radio, :set_exhaust, :set_steering
  
  belongs_to :vehicle
  belongs_to :user
  belongs_to :event
  
  FUEL_LEVELS = ['Full', '3/4', '1/2', '1/4', 'None']
  
  def set_fuel_level
      self.fuel_level = "Checked" if self.fuel_level.blank?
    end
 
  def set_wash
      self.wash = "Checked" if self.wash.blank?
    end
 
  def set_suspension
      self.suspension = "Checked" if self.suspension.blank?
    end

  def set_drive_train
      self.drive_train = "Checked" if self.drive_train.blank?
    end

  def set_body
      self.body = "Checked" if self.body.blank?
    end

  def set_brake
      self.brake = "Checked" if self.brake.blank?
    end
 
  def set_safety_equipment
      self.safety_equipment = "Checked" if self.safety_equipment.blank?
    end

  def set_electrcial
      self.electrical = "Checked" if self.electrical.blank?
    end

  def set_cooling_system
      self.cooling_system = "Checked" if self.cooling_system.blank?
    end
 
  def set_exhaust
      self.exhaust = "Checked" if self.exhaust.blank?
    end
  
  def set_steering
      self.steering = "Checked" if self.steering.blank?
    end
  def set_engine
      self.engine = "Checked" if self.engine.blank?
  end
  
  def set_chassis
    self.chassis = "Checked" if self.chassis.blank?
  end
  
  def set_radio
    self.radio = "Checked" if self.radio.blank?
  end
  
  def set_tires
    self.tires = "Checked" if self.tires.blank?
  end
  
  
end
