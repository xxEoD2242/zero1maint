class CreatePartRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :part_requests do |t|
      t.integer :part_id
      t.integer :request_id

      t.timestamps
    end
  end
end
