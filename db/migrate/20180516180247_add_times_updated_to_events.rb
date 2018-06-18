# frozen_string_literal: true

class AddTimesUpdatedToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :times_updated, :integer
  end
end
