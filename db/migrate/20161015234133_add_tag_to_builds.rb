class AddTagToBuilds < ActiveRecord::Migration[5.0]
  def change
    add_column :builds, :tag, :string
  end
end
