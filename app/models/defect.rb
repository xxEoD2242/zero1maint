# frozen_string_literal: true

class Defect < ApplicationRecord
  belongs_to :vehicle
  belongs_to :checklist
  
  has_many :defect_requests
  has_many :requests, through: :defect_requests
  
  paginates_per 20
  
  def user_naming
    "&nbsp; #{description} &nbsp;".html_safe
  end
end
