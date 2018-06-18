# frozen_string_literal: true

json.extract! report, :id, :title, :description, :user_id, :created_at, :updated_at
json.url report_url(report, format: :json)
