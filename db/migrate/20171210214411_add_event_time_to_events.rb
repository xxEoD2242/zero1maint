# frozen_string_literal: true

class AddEventTimeToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :event_time, :time
  end
end
