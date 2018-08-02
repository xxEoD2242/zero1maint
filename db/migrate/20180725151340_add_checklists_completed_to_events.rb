# frozen_string_literal: true

class AddChecklistsCompletedToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :checklists_completed, :boolean
  end
end
