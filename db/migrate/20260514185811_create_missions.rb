class CreateMissions < ActiveRecord::Migration[8.1]
  def change
    create_table :missions do |t|
      t.string :title
      t.text :description
      t.integer :difficulty
      t.references :agent, null: false, foreign_key: true

      t.timestamps
    end
  end
end
