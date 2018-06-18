# frozen_string_literal: true

class AddServiceIdToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :service_id, :integer
  end
end
