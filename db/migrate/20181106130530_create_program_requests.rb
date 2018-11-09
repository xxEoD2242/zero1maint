class CreateProgramRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :program_requests do |t|
      t.integer :program_id
      t.integer :request_id

      t.timestamps
    end
  end
end
