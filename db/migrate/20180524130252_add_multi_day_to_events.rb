# frozen_string_literal: true

class AddMultiDayToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :multi_day, :boolean
  end
end
