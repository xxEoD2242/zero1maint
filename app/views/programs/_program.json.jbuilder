# frozen_string_literal: true

json.extract! program, :id, :name, :interval, :created_at, :updated_at
json.url program_url(program, format: :json)
