class AddThresholdToPrograms < ActiveRecord::Migration[5.1]
  def change
    add_column :programs, :threshold, :boolean
  end
end
