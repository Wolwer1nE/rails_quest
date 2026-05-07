class Quest2StudentService
  class << self

    # @return [String]
    def all_agents
      Agent.all.pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      Mission.all.pluck(:title).sort.join("\n") # Можно сортировать в базе, но так проще
    end

    # @return [String]
    def agents_with_missions
      # Includes нужен, чтобы избежать N+1 запроса к базе данных, смотрим N+1 при ручной проверке
      Agent.includes(:missions).map do |agent|
        "#{agent.codename}: #{agent.missions.pluck(:title).join(", ")}"
      end.join("\n")
      # Можно исхитриться с joins и group, но так проще, мне кажется
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      # тут можно прям рассказать про left_joins, group, order и select
      # смотрите за руками: вот тут join без прелоада может привести к N+1 запросу
      # Agent.left_joins(:missions)
      #      .select("agents.*, COUNT(missions.id) AS missions_count")
      #      .group("agents.id")
      #      .order("missions_count DESC")
      #      .preload(:missions)
      #      .map do |agent|
      #        "#{agent.codename} (#{agent.missions_count}): #{agent.missions.pluck(:title).join(", ")}"
      #      end.join("\n")

      Agent.includes(:missions).sort_by { |agent| [-agent.missions.size, agent.codename] }
                                  .map do |agent|
        titles = agent.missions.map(&:title).sort
        "#{agent.codename} (#{agent.missions.size}): #{titles.join(", ")}"
        # Тут я даже предлагаю простить студенту N+1 запрос и разрезание запроса на несколько, чтобы не усложнять код.
      end
                                  .join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.includes(:skills).map do |agent|
        "#{agent.codename}: #{agent.skills.pluck(:name).join(", ")}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      Skill.includes(:agents)
           .sort_by { |skill| [-skill.agents.size, skill.name] }
           .map do |skill|
        "#{skill.name} (#{skill.agents.size}): #{skill.agents.sort_by(&:codename).pluck(:codename).join(", ")}"
      end.join("\n")
    end
  end
end
