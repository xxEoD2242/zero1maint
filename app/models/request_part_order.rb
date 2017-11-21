class RequestPartOrder < ApplicationRecord
  has_many :part_items
  belongs_to :request
  belongs_to :user
  
  serialize :order_items, Hash
end
