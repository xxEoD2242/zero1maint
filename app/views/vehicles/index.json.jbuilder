# frozen_string_literal: true

json.array! @vehicles, partial: 'vehicles/vehicle', as: :vehicle
