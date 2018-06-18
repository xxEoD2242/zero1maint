# frozen_string_literal: true

class AddCompletedToPrograms < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :completed, :boolean
  end
end
