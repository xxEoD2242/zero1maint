class ReportVehicle < ApplicationRecord
  belongs_to :vehicle
  belongs_to :report
end
