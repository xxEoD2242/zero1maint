class ReportVehicleOrder < ApplicationRecord
  belongs_to :report
  
  serialize :request_miles, Hash
end
