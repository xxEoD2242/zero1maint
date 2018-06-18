# frozen_string_literal: true

json.extract! vehicle, :id, :car_id, :car_category_id, :manufacturer, :status, :vin_number, :registration_date, :plate_number, :request_id, :mileage_id, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)
