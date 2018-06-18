# frozen_string_literal: true

class AddImageToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :image, :string
  end
end
