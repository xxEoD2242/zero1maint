class Event < ApplicationRecord
  belongs_to :location
  has_many :vehicles
end
