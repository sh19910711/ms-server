class AddDeviceSecretIndexToDevices < ActiveRecord::Migration[5.0]
  def change
    add_index :devices, :device_secret
  end
end
