class Leaderboard
  def self.leaderboard(competition)
    leaderboard_entries = []

    competition.participants.each do |participant|
      participant_total = 0

      competition.experiments.each do |experiment|
        experiment_best_quality = experiment.best_quality
        participant_best_quality = participant.best_quality(experiment.id)

        if participant_best_quality != nil and experiment_best_quality != nil
          participant_total += experiment_best_quality.to_f / participant_best_quality
        end
      end

      leaderboard_entries.push(LeaderboardEntry.new(participant, participant_total))
    end

    leaderboard_entries.sort! { |a,b| a.score <=> b.score }

    leaderboard_entries.reverse!
  end
end
