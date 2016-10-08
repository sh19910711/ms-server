class CreateAuthTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_tokens do |t|
      t.string :client
      t.string :uid
      t.string :access_token
      t.datetime :expires_at
      t.string :description
      t.string :token

      t.timestamps
    end
    add_index :auth_tokens, :token, unique: true
  end
end
