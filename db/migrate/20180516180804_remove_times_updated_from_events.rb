# frozen_string_literal: true

class RemoveTimesUpdatedFromEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :times_updated, :integer
  end
end
