class Request < ApplicationRecord
  belongs_to :tracker
  belongs_to :user
  belongs_to :vehicle
  mount_uploader :image, ImageUploader
end
