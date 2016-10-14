class RenameRandIdToDeviceSecretInDevices < ActiveRecord::Migration[5.0]
  def change
    rename_column :devices, :rand_id, :device_secret
  end
end
