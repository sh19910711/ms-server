class AddBoardToDevice < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :board, :string
  end
end
