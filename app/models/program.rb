# frozen_string_literal: true

class Program < ApplicationRecord
  has_many :vehicles, through: :requests

  has_many :program_requests
  has_many :requests, through: :program_requests

  validates :rzr_interval, :tour_car_interval, :training_interval, :db_interval, :other_interval, :fleet_interval, presence: true

  scope :a_service, -> { find_by(name: 'A-Service') }
  scope :shock_service, -> { find_by(name: 'Shock Service') }
  scope :air_filter_service, -> { find_by(name: 'Air Filter Change') }
  scope :tour_car_prep, -> { find_by(name: 'Tour Car Prep') }
  scope :defect, -> { find_by(name: 'Defect') }
  scope :repairs, -> { find_by(name: 'Repairs') }
  scope :other_service, -> { find_by(name: 'Other Service') }
  
  def user_naming
    "&nbsp; #{name} &nbsp;".html_safe
  end
end
