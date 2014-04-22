module PlanductorChart
  def self.quality_chart(competition, participant=nil)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Experiment')

    competition.participants.each do |participant|
      data_table.new_column('number', participant.planner.name)
    end

    competition.experiments.sort_by{|x| x.experiment_number}.each do |experiment|
      row = [experiment.experiment_number.to_s]

      competition.participants.each do |participant|
        row.push(participant.best_quality(experiment.id))
      end

      data_table.add_row(row)
    end

    option = { title: 'Participant quality values for each experiment', height: 400}

    GoogleVisualr::Interactive::LineChart.new(data_table, option)
  end

  def self.score_chart(competition, participant=nil)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Experiment')

    competition.participants.each do |participant|
      data_table.new_column('number', participant.planner.name)
    end

    competition.experiments.sort_by{|x| x.experiment_number}.each do |experiment|
      row = [experiment.experiment_number.to_s]
      best_quality = experiment.best_quality

      competition.participants.each do |participant|
        participant_best_quality = participant.best_quality(experiment.id)

        if participant_best_quality == nil or best_quality == nil
          row.push(0)
        else
          row.push(best_quality.to_f / participant_best_quality)
        end
      end

      data_table.add_row(row)
    end

    option = { title: 'Participant scores for each experiment', height: 400 }

    GoogleVisualr::Interactive::LineChart.new(data_table, option)
  end
end
