# frozen_string_literal: true

class ChangeLastShockColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :vehicles, :last_sock_service, :last_shock_service
  end
end
