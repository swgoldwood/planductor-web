module PlanductorChart
  def self.quality_chart(competition, participant=nil)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Experiment')

    competition.participants.each do |participant|
      data_table.new_column('number', participant.planner.name)
    end

    count = 1 #TODO really don't like how I'm numbering the tasks per competition...
    competition.experiments.each do |experiment|
      row = ['Experiment ' + count.to_s]

      competition.participants.each do |participant|
        row.push(participant.best_quality(experiment.id))
      end

      data_table.add_row(row)
      count += 1
    end

    option = { title: 'Participant quality values for each experiment' }

    GoogleVisualr::Interactive::BarChart.new(data_table, option)
  end

  def self.score_chart(competition, participant=nil)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Experiment')

    competition.participants.each do |participant|
      data_table.new_column('number', participant.planner.name)
    end

    count = 1
    competition.experiments.each do |experiment|
      row = ['Experiment ' + count.to_s]
      best_quality = experiment.best_quality

      competition.participants.each do |participant|
        if best_quality == nil
          row.push(nil)
        else
          row.push(best_quality.to_f / participant.best_quality(experiment.id))
        end
      end

      data_table.add_row(row)
      count += 1
    end

    option = { title: 'Participant scores for each experiment', hAxis: { viewWindow: { max: 1}  } }

    GoogleVisualr::Interactive::BarChart.new(data_table, option)
  end
end
