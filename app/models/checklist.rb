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
  
  scope :completed?, -> { where(defect: true) }
  scope :have_defects?, -> { where(defect: true) }

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
    @vehicle = vehicle
    if deadline
      @vehicle.update(vehicle_status: 'Out-of-Service', repair_needed: true)
      Request.create(status: 'New',
                     description: 'Vehicle failed pre-operation inspection. Please refer to checklist for defects detected or repairs needed.',
                     vehicle_id: @vehicle.id, creator: User.find(user_id).name, program_id: @set_repairs.id,
                     completion_date: (Time.now + 7.days), request_mileage: @vehicle.mileage,
                     checklist_id: id, completed_date: Date.current)
    end
  end

  def defects_detected
    maintenance = %w[engine suspension steering tires
                     radio chassis exhaust cooling_system
                     electrical safety_equipment brake body
                     drive_train suspension]
    attributes.each do |k, v|
      self.defect = true if v != 'Checked' && maintenance.include?(k)
    end
  end

  def has_defects?
    defect == true
  end

  def create_defect
    ids = []
    (1..100000).each do |numb|
      string = numb.to_s
      ids << string
    end
    @last_defect_id = Defect.last.id
    maintenance = %w[engine suspension steering tires
                     radio chassis exhaust cooling_system
                     electrical safety_equipment brake body
                     drive_train suspension]
    self.attributes.each do |k, v|
      if v != 'Checked' && maintenance.include?(k) && !ids.include?(v)
        @new_defect = Defect.create(description: v, checklist_id: id, vehicle_id: vehicle.id, category: k, times_reported: 0, last_event_reported: self.event_id)
      elsif v != 'Checked' && maintenance.include?(k) && ids.include?(v)
        if v.to_i < @last_defect_id
        @defect = Defect.where(id: v).last
        @defect.update(times_reported: (@defect.times_reported + 1), last_event_reported: self.event_id)
        end
      end
    end
  end
end
