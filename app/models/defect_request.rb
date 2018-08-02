class DefectRequest < ApplicationRecord
  belongs_to :defect
  belongs_to :request
end
