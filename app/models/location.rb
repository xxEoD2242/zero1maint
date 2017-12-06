class Location < ApplicationRecord
  has_many :events, inverse_of: :location
  has_many :vehicles
end
