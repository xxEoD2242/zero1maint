class Program < ApplicationRecord
  has_many :vehicles, through: :requests
  has_many :requests
end
