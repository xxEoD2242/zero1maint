# frozen_string_literal: true

class Defect < ApplicationRecord
  belongs_to :vehicle
  
  has_many :defect_requests
  has_many :requests, through: :defect_requests
  
  has_many :checklist_defects
  has_many :checklists, through: :checklist_defects
  
  paginates_per 20
  
  before_create :set_times_completed
  before_create :set_times_reported
  before_save :track_times_completed
  
  scope :are_fixed?, -> { where(fixed: true) }
  scope :are_not_fixed?, -> { where(fixed: false) }
  
  MAINTENANCE = ['Engine', 'Suspension', 'Steering', 'Tires',
                   'Radio', 'Chassis', 'Exhaust', 'Cooling System',
                   'Electrical', 'Safety Equipment', 'Brakes', 'Body',
                   'Drive Train', 'Suspension', 'Other']
  
  def user_naming
    "&nbsp; #{description} &nbsp;".html_safe
  end
  
  def fixed?
    fixed == true
  end
  
  def set_times_completed
    self.times_completed = 0
  end

  def set_times_reported
    self.times_reported = 0
  end

  def track_times_completed
    if self.fixed? && self.times_completed == 0
      self.times_completed = (self.times_completed + 1)
      self.mechanic = User.find(self.user_id).name
    elsif self.fixed? && self.times_completed != 0
      self.times_completed = (self.times_completed + 1)
    end
  end
end
