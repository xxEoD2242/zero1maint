# frozen_string_literal: true

class AddNumberToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :number, :integer
  end
end
