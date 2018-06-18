# frozen_string_literal: true

class RequestPartOrder < ApplicationRecord
  has_many :part_items
  belongs_to :request, optional: true
  belongs_to :user

  serialize :order_items, Hash
end
