class Vehicle < ApplicationRecord
 
  belongs_to :event
  belongs_to :vehicle_category
  has_many :requests
  belongs_to :location
end
