class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      # Mission.pluck(:title).sort.join("\n") - сортировка через язык
      # сортировка через запросы к базе
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent.order(:codename).includes(:missions).map do |agent|
        lst_missions = agent.missions.order(:title).pluck(:title).join(", ")
        "#{agent.codename}: #{lst_missions}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      Agent.left_joins(:missions)
        .group(:id)
        .order("COUNT(missions.id) DESC")
        .order(codename: :asc)
        .includes(:missions).map do |agent|
          lst_missions = agent.missions.order(:title).pluck(:title).join(", ")
          "#{agent.codename} (#{agent.missions.size}): #{lst_missions}"
        end.join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.order(:codename).includes(:skills).map do |agent|
        lst_skills = agent.skills.order(:name).pluck(:name).join(", ")
        "#{agent.codename}: #{lst_skills}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      Skill.left_joins(:agents)
           .group(:id)
           .order("COUNT(agents.id) DESC")
           .includes(:agents).map do |skill|
             lst_agents = skill.agents.order(:codename).pluck(:codename).join(", ")
             "#{skill.name} (#{skill.agents.size}): #{lst_agents}"
           end.join("\n")
    end
  end
end
