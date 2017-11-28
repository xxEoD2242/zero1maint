class RequestReport < ApplicationRecord
  belongs_to :request
  belongs_to :report
end
