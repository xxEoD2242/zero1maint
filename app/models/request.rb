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
end
