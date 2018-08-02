# frozen_string_literal: true

class AddDefectsReportedToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :defects_reported, :boolean
  end
end
