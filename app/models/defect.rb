class Defect < ApplicationRecord
  belongs_to :vehicle
  belongs_to :checklist
end
