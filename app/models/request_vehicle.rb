class RequestVehicle < ApplicationRecord
  belongs_to :request
  belongs_to :vehicle
end
