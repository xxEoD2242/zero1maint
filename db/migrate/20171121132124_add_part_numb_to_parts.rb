# frozen_string_literal: true

class AddPartNumbToParts < ActiveRecord::Migration[5.1]
  def change
    add_column :parts, :part_numb, :string
  end
end
