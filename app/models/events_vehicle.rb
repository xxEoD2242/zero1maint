class EventsVehicle < ApplicationRecord
  belongs_to :event
  belongs_to :vehicle
end
