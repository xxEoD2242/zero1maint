# frozen_string_literal: true

class AddChecklistNumbToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :checklist_numb, :integer
  end
end
