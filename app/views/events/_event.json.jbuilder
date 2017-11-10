json.extract! event, :id, :date, :event_mileage, :location_id, :duration, :event_type, :class_type, :created_at, :updated_at
json.url event_url(event, format: :json)
