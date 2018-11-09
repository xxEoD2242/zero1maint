# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :vehicle

  has_many :request_users
  has_many :users, through: :request_users

  has_many :part_requests
  has_many :parts, through: :part_requests
  
  has_many :defect_requests
  has_many :defects, through: :defect_requests

  has_many :request_part_orders
  
  has_many :program_requests
  has_many :programs, through: :program_requests

  validates :description, presence: true
  validates :completion_date, presence: true

  mount_uploader :image, ImageUploader

  paginates_per 10

  accepts_nested_attributes_for :vehicle, :parts
  
  after_save :set_defects_fixed, only: [:update]
  after_save :a_service_update, :shock_service_update, :air_filter_service_update, :tour_car_prep_update, :defect_update, :repairs_update
  before_save :track_times_completed

  STATUS = ['New', 'In-Progress', 'Completed', 'Overdue'].freeze

  scope :is_new, -> { where(status: 'New') }
  scope :is_in_progress, -> { where(status: 'In-Progress') }
  scope :is_completed, -> { where(status: 'Completed') }
  scope :is_overdue, -> { where(status: 'Overdue') }
  scope :is_an_a_service, -> { where(a_service: true) }
  scope :is_a_shock_service, -> { where(shock_service: true) }
  scope :is_a_air_filter_service, -> { where(air_filter_service: true) }
  scope :is_a_repair, -> { where(repairs: true) }
  scope :is_a_defect, -> { where(defect: true) }
  scope :is_a_tour_car_prep, -> { where(tour_car_prep: true) }

  def set_defects_fixed
    if self.completed?
      self.defects.update(fixed: true, date_fixed: self.completed_date, user_id: self.mechanic_id,
                          repair: self.description)
    end
  end
  
  def new?
    status == 'New'
  end

  def in_progress?
    status == 'In-Progress'
  end

  def completed?
    status == 'Completed'
  end

  def overdue?
    status == 'Overdue'
  end
 
  def a_service?
    program_id == Program.a_service.id
  end

  def shock_service?
    program_id == Program.shock_service.id
  end
 
  def air_filter_service?
    program_id == Program.air_filter_service.id
  end

  def repairs?
    program_id == Program.repairs.id
  end

  def defect?
    program_id == Program.defect.id
  end

  def tour_car_prep?
    program_id == Program.tour_car_prep.id
  end
  
  def self.one_week?
    where('created_at >= ?', (Date.current - 7.days))
  end
  
  def a_service_update
    vehicle = self.vehicle
    veh_mileage = self.vehicle.mileage
    if self.programs.ids.include?(Program.a_service.id) && self.completed? 
      vehicle.update(last_a_service: veh_mileage)
    end
    if self.programs.ids.include?(Program.a_service.id)
      self.a_service = true
    end
  end
  
  def shock_service_update
    vehicle = self.vehicle
    veh_mileage = self.vehicle.mileage
    if self.programs.ids.include?(Program.shock_service.id) && self.completed?
      vehicle.update(last_shock_service: veh_mileage)
    end
    if self.programs.ids.include?(Program.shock_service.id)
      self.shock_service = true
    end
  end
  
  def air_filter_service_update
    vehicle = self.vehicle
    veh_mileage = self.vehicle.mileage
    if self.programs.ids.include?(Program.air_filter_service.id) && self.completed?
      vehicle.update(last_air_filter_service: veh_mileage)
    end
    if self.programs.ids.include?(Program.air_filter_service.id)
      self.air_filter_service = true
    end
  end
  
  def tour_car_prep_update
    vehicle = self.vehicle
    veh_mileage = self.vehicle.mileage
    if self.programs.ids.include?(Program.tour_car_prep.id) && self.completed?
      vehicle.update(tour_car_prep: false, needs_service: false, vehicle_status: 'In-Service', last_tour_car_prep_mileage: veh_mileage)
    end
    if self.programs.ids.include?(Program.tour_car_prep.id)
      self.tour_car_prep = true
    end
  end
  
  def defect_update
    vehicle = self.vehicle
    veh_mileage = vehicle.mileage
    if self.programs.ids.include?(Program.defect.id) && self.completed?
      vehicle.update(defect: false, needs_service: false, vehicle_status: 'In-Service')
      defect_email
    end
    if self.programs.ids.include?(Program.defect.id)
      self.defect = true
    end
  end
  
  def repairs_update
    vehicle = self.vehicle
    veh_mileage = vehicle.mileage
    if self.programs.ids.include?(Program.repairs.id) && self.completed?
      vehicle.update(vehicle_status: "In-Service", repair_needed: false, needs_service: false)
    elsif self.programs.ids.include?(Program.repairs.id)
      vehicle.update(vehicle_status: "Out-of-Service", repair_needed: true, needs_service: true)
    end
  end
  
  def defect_email
    if self.users.exists?
      defect_emails = []
      self.users.all.each do |user|
        defect_emails << user.email
      end
      UserMailer.new_request_email(defect_emails, self).deliver_now
    end
  end

  def track_times_completed
    if self.completed? && self.times_completed == 0
      self.times_completed = (self.times_completed + 1)
      self.mechanic = User.find(self.mechanic_id).name
    elsif self.completed?
      self.times_completed = (self.times_completed + 1)
    end
  end
end
