class ChangeDateTypeOfEvents < ActiveRecord::Migration[5.1]
  def change
    change_column(:events, :date, :date)
  end
end
