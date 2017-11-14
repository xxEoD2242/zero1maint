class Request < ApplicationRecord
  belongs_to :tracker
  belongs_to :user
  belongs_to :program
  belongs_to :vehicle
 
  mount_uploader :image, ImageUploader
  
  paginates_per 5
  
end
