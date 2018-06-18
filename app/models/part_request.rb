# frozen_string_literal: true

class PartRequest < ApplicationRecord
  belongs_to :request
  belongs_to :part
end
