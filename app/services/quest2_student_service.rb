class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent.all.map do |agent|
        "#{agent.codename}: #{agent.missions.pluck(:title).join(', ')}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      Agent.all.map { |agent| [agent, agent.missions.count] }.sort_by { |a, count| [-a.missions.count, a.codename] }
      .map { |agent, count| "#{agent.codename} (#{count}): #{agent.missions.pluck(:title).join(', ')}" }
      .join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.all.map do |agent|
        "#{agent.codename}: #{agent.skills.pluck(:name).join(', ')}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
       Skill.all.sort_by { |s| [-s.agents.count, s.name] }.map { |s| "#{s.name} (#{s.agents.count}): #{s.agents.pluck(:codename).sort.join(', ')}" }
      .join("\n")
    end
  end
end
