class AddStatusToDevice < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :status, :string
  end
end
