class AddHeartbeatedAtToDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :heartbeated_at, :datetime
  end
end
