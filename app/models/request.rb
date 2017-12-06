class Request < ApplicationRecord
  belongs_to :tracker
  belongs_to :user
  belongs_to :program
  belongs_to :vehicle
  
  
  has_many :part_requests
  has_many :parts, through: :part_requests
  
  has_many :request_part_orders
  
  validates :tracker, presence: {message: "- Please provide a status for the Work Order"}
  validates :program, presence: true
  validates :vehicle, presence: true
  validates :description, presence: true
  validates_with DateValidator 
 
  mount_uploader :image, ImageUploader
  
  paginates_per 5
  
  accepts_nested_attributes_for :vehicle, :parts
end
