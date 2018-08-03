# frozen_string_literal: true

class Defect < ApplicationRecord
  belongs_to :vehicle
  
  has_many :defect_requests
  has_many :requests, through: :defect_requests
  
  has_many :checklist_defects
  has_many :checklists, through: :checklist_defects
  
  paginates_per 20
  
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
end
