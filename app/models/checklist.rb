# frozen_string_literal: true

class Checklist < ApplicationRecord
  before_save :set_fuel_level, :set_date, :set_wash,
              :set_suspension, :set_drive_train, :set_body, 
              :set_engine, :set_brake, :set_safety_equipment, 
              :set_chassis, :set_electrcial, :set_cooling_system, 
              :set_tires, :set_radio, :set_exhaust, :set_steering,
              :defects_detected, :deadlined, :completed
  after_save :create_defect
  belongs_to :vehicle
  belongs_to :user
  belongs_to :event
  has_many :defects
  

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
  
  def completed
    self.completed = true
  end
  
  def deadlined
    @set_repairs = Program.find_by(name: 'Repairs')
    @vehicle = self.vehicle
    if deadline
      @vehicle.update(vehicle_status: 'Out-of-Service', repair_needed: true)
      Request.create(status: 'New', 
      description: 'Vehicle failed pre-operation inspection. Please refer to checklist for defects detected or repairs needed.',
      vehicle_id: @vehicle.id, creator: User.find(self.user_id).name, program_id: @set_repairs.id,
      completion_date: (Time.now + 7.days), request_mileage: @vehicle.mileage,
      checklist_id: self.id, completed_date: Date.current)
    end
  end
  
  def defects_detected 
    maintenance = self.attribute_names.slice(5..13)
    self.attributes.each do |k,v|
      if v != 'Checked' && maintenance.include?(k)
        self.defect = true
      end
    end
  end
  
  def has_defects?
    defect == true
  end
  
  def create_defect
    maintenance = self.attribute_names.slice(5..13)
    self.attributes.each do |k,v|
      if v != 'Checked' && maintenance.include?(k)
        Defect.create(description: v, checklist_id: self.id, vehicle_id: self.vehicle.id, category: k)
      end
    end
  end
end
