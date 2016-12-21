class AddDeviceSecretPrefixToDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :device_secret_prefix, :string
    add_index :devices, :device_secret_prefix, unique: true
  end
end
