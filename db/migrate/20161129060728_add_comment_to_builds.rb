class AddCommentToBuilds < ActiveRecord::Migration[5.0]
  def change
    add_column :builds, :comment, :string
  end
end
