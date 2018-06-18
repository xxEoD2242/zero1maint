# frozen_string_literal: true

json.extract! request, :id, :number, :description, :status, :special_requets, :completion_date, :poc, :created_at, :updated_at
json.url request_url(request, format: :json)
