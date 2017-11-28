class PartReport < ApplicationRecord
  belongs_to :report
  belongs_to :part
end
