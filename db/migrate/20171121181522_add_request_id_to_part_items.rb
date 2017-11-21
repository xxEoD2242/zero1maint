class AddRequestIdToPartItems < ActiveRecord::Migration[5.1]
  def change
    add_column :part_items, :request_id, :integer
  end
end
