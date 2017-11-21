class VehicleCategory < ApplicationRecord
  has_many :vehicles
  has_many :parts
end
