# frozen_string_literal: true

json.extract! part, :id, :part_id, :description, :brand, :category, :cost, :quantity, :created_at, :updated_at, :vehicle_category_id
json.url part_url(part, format: :json)
