# frozen_string_literal: true

class Request < ApplicationRecord
  has_many :request_vehicles
  has_many :vehicles, through: :request_vehicles

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

  accepts_nested_attributes_for :parts
  
  after_save :set_defects_fixed, only: [:update]
  
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
      self.mechanic = User.find(self.user_id).name
    elsif self.completed?
      self.times_completed = (self.times_completed + 1)
    end
  end
end
