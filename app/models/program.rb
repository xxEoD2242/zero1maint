# frozen_string_literal: true

class Program < ApplicationRecord
  has_many :requests, inverse_of: :program
  has_many :vehicles, through: :requests

  validates :interval, presence: true
end
