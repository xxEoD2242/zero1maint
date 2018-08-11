# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :program
  belongs_to :vehicle

  has_many :request_users
  has_many :users, through: :request_users

  has_many :part_requests
  has_many :parts, through: :part_requests
  
  has_many :defect_requests
  has_many :defects, through: :defect_requests

  has_many :request_part_orders

  validates :description, presence: true
  validates :completion_date, presence: true

  mount_uploader :image, ImageUploader

  paginates_per 10

  accepts_nested_attributes_for :vehicle, :parts
  
  after_save :set_defects_fixed, only: [:update]
  after_save :update_service_mileage

  STATUS = ['New', 'In-Progress', 'Completed', 'Overdue'].freeze

  scope :is_new, -> { where(status: 'New') }
  scope :is_in_progress, -> { where(status: 'In-Progress') }
  scope :is_completed, -> { where(status: 'Completed') }
  scope :is_overdue, -> { where(status: 'Overdue') }
  scope :is_an_a_service, -> { where(program_id: Program.a_service.id) }
  scope :is_a_shock_service, -> { where(program_id: Program.shock_service.id) }
  scope :is_a_air_filter_service, -> { where(program_id: Program.air_filter_service.id) }
  scope :is_a_repair, -> { where(program_id: Program.repairs.id) }
  scope :is_a_defect, -> { where(program_id: Program.defect.id) }
  scope :is_a_tour_car_prep, -> { where(program_id: Program.tour_car_prep.id) }

  def set_defects_fixed
    if self.completed?
      self.defects.update(fixed: true, date_fixed: self.completed_date)
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
    program_id == Program.defect.id
  end
  
  def update_service_mileage
    vehicle = self.vehicle
    veh_mileage = self.vehicle.mileage
    if self.a_service? && self.completed? 
      vehicle.update(last_a_service: veh_mileage)
    elsif self.shock_service? && self.completed?
      vehicle.update(last_shock_service: veh_mileage)
    elsif self.air_filter_service? && self.completed?
      vehicle.update(last_air_filter_service: veh_mileage)
    elsif self.repairs? && self.completed?
      vehicle.update(repair_needed: false, needs_service: false, vehicle_status: 'In-Service')
    elsif self.tour_car_prep? && self.completed?
      vehicle.update(tour_car_prep: false, needs_service: false, vehicle_status: 'In-Service', last_tour_car_prep_mileage: veh_mileage)
    elsif self.defect? && self.completed?
      vehicle.update(defect: false, needs_service: false, vehicle_status: 'In-Service')
      defect_email
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
end
