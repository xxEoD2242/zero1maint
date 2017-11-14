class Request < ApplicationRecord
  belongs_to :tracker
  belongs_to :user
  belongs_to :vehicle
  belongs_to :program
  mount_uploader :image, ImageUploader
  
  paginates_per 5
end
