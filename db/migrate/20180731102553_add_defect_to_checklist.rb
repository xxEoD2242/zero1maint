# frozen_string_literal: true

class AddDefectToChecklist < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :defect, :boolean, default: false
  end
end
