# frozen_string_literal: true

class AddDurationWordToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :duration_word, :string
  end
end
