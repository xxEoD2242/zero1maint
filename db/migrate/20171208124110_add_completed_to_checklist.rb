# frozen_string_literal: true

class AddCompletedToChecklist < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :completed, :boolean
  end
end
