class CreateTasks
  @queue = :task_queue

  def self.perform(participant_id, competition_id)
    participant = Participant.find_by_id(participant_id)
    competition = Competition.find_by_id(competition_id)

    competition.experiments.each do |experiment|
      task = participant.tasks.build
      task.experiment_id = experiment.id

      task.save!
    end
  end
end
