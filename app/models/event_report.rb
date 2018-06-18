# frozen_string_literal: true

class EventReport < ApplicationRecord
  belongs_to :event
  belongs_to :report
end
