class AddProgramIdToRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :requests, :program_id, :integer
  end
end
