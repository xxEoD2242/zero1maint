class AddTypeToChecklists < ActiveRecord::Migration[5.1]
  def change
    add_column :checklists, :checklist_type, :string, default: ""
  end
end
