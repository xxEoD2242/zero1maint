class Vehicle < ApplicationRecord
  has_one :mileage
  belongs_to :vehicle_category
  has_many :requests
end
