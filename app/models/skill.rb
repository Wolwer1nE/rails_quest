class Skill < ApplicationRecord
  has_many :agent_skills
  has_many :agents, through: :agent_skills
end
