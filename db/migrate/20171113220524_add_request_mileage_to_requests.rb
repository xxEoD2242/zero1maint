# frozen_string_literal: true

class AddRequestMileageToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :request_mileage, :float
  end
end
