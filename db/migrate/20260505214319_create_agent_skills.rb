class CreateAgentSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :agent_skills do |t|
      t.references :agent, null: false, foreign_key: true, type: :integer
      t.references :skill, null: false, foreign_key: true, type: :integer

      t.timestamps
    end
  end
end
