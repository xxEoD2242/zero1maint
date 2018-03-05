class VehicleCategory < ApplicationRecord
  has_many :vehicles, inverse_of: :vehicle_category

end
