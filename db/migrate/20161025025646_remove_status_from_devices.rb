class RemoveStatusFromDevices < ActiveRecord::Migration[5.0]
  def change
    remove_column :devices, :status
  end
end
