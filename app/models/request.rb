# frozen_string_literal: true

class Request < ApplicationRecord
  belongs_to :program
  belongs_to :vehicle

  has_many :request_users
  has_many :users, through: :request_users

  has_many :part_requests
  has_many :parts, through: :part_requests

  has_many :request_part_orders

  validates :description, presence: true
  validates :completion_date, presence: true

  mount_uploader :image, ImageUploader

  paginates_per 5

  accepts_nested_attributes_for :vehicle, :parts

  STATUS = ['New', 'In-Progress', 'Completed', 'Overdue'].freeze
  
  scope :is_new, -> { where(status: "New") }
  scope :is_in_progress, -> { where(status: "In-Progress") }
  scope :is_completed, -> { where(status: "Completed") }
  scope :is_overdue, -> { where(status: "Overdue") }
  scope :is_an_a_service, -> { where(program_id: Program.a_service.id) }
  scope :is_a_shock_service, -> { where(program_id: Program.shock_service.id) }
  scope :is_a_air_filter_service, -> { where(program_id: Program.air_filter_service.id) }
  scope :is_a_repair, -> { where(program_id: Program.repairs.id) }
  scope :is_a_defect, -> { where(program_id: Program.defect.id) }
  scope :is_a_tour_car_prep, -> { where(program_id: Program.tour_car_prep.id) }
end
