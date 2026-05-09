class Agent < ApplicationRecord
  has_many :missions
  has_many :agent_skills
  has_many :skills, through: :agent_skills
end
