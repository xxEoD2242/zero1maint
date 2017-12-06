class VehicleCategory < ApplicationRecord
  has_many :vehicles, inverse_of: :vehicle_category
  has_many :parts
end
