class Request < ApplicationRecord
  has_many :trackers

  
  mount_uploader :image, ImageUploader
end
