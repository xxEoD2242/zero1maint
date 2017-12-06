class Program < ApplicationRecord
  has_many :requests, inverse_of: :program
  has_many :vehicles, through: :requests
end
