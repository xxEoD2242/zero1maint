class Request < ApplicationRecord

  belongs_to :program
  belongs_to :vehicle
  
  has_many :request_users
  has_many :users, through: :request_users
  
  has_many :part_requests
  has_many :parts, through: :part_requests
  
  has_many :request_part_orders
  
  
  validates :description, presence: true

 
  mount_uploader :image, ImageUploader
  
  paginates_per 5
  
  accepts_nested_attributes_for :vehicle, :parts
  
  STATUS = ['New', 'In-Progress', "Completed", "Overdue"]
  
  
end
