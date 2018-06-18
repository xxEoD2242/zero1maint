# frozen_string_literal: true

class PartItem < ApplicationRecord
  attr_accessor :custom_field

  belongs_to :part
  belongs_to :order, optional: true
end
