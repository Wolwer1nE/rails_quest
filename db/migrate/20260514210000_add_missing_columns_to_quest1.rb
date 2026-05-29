class AddMissingColumnsToQuest1 < ActiveRecord::Migration[8.1]
  def change
    add_column :agents, :codename, :string unless column_exists?(:agents, :codename)
    add_column :agents, :active, :boolean unless column_exists?(:agents, :active)
    add_column :skills, :category, :string unless column_exists?(:skills, :category)
    add_column :missions, :status, :string unless column_exists?(:missions, :status)

    add_index :agents, :codename, unique: true unless index_exists?(:agents, :codename)
    add_index :skills, :name, unique: true unless index_exists?(:skills, :name)
    add_index :agent_skills, [:agent_id, :skill_id], unique: true unless index_exists?(:agent_skills, [:agent_id, :skill_id])
  end
end
