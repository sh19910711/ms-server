class DropAuthToken < ActiveRecord::Migration[5.0]
  def change
    drop_table :auth_tokens
  end
end
