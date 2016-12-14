class RemoveUnusedColumnsFromBuilds < ActiveRecord::Migration[5.0]
  def change
    remove_column :builds, :tag
    remove_column :builds, :comment
  end
end
