class CreateBuilds < ActiveRecord::Migration[5.0]
  def change
    create_table :builds do |t|
      t.references :app, foreign_key: true
      t.string :status
      t.text :log
      t.string :source_file

      t.timestamps
    end
  end
end
