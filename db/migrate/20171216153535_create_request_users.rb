# frozen_string_literal: true

class CreateRequestUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :request_users do |t|
      t.integer :request_id
      t.integer :user_id

      t.timestamps
    end
  end
end
