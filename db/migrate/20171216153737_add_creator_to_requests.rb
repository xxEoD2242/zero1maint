class AddCreatorToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :creator, :string
  end
end
