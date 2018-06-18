# frozen_string_literal: true

class RequestUser < ApplicationRecord
  belongs_to :request
  belongs_to :user
end
