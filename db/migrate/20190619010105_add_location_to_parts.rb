class AddLocationToParts < ActiveRecord::Migration[5.1]
  def change
    add_column :parts, :location, :string, default: "RZR Basecamp"
  end
end
