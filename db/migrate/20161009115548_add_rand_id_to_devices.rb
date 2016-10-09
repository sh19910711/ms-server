class AddRandIdToDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :rand_id, :string
  end
end
