# frozen_string_literal: true

class AddLaborToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :labor, :float
  end
end
