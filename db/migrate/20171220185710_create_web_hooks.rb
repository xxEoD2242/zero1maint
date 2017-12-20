class CreateWebHooks < ActiveRecord::Migration[5.1]
  def change
    create_table :web_hooks do |t|
      t.string :data
      t.string :integration

      t.timestamps
    end
  end
end
