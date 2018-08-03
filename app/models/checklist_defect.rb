class ChecklistDefect < ApplicationRecord
  belongs_to :checklist
  belongs_to :defect
end
