class Participant < ActiveRecord::Base
  attr_accessible :competition_id, :planner_id

  has_many :tasks, dependent: :destroy

  belongs_to :competition
  belongs_to :planner

  validates :competition_id, presence: :true
  validates :planner_id, presence: true
  validates_uniqueness_of :competition_id, scope: :planner_id

  def best_score(experiment_id)
    task = Task.where(participant_id: self.id, experiment_id: experiment_id).first

    if task
      results = task.results
      if results.any?
        best = nil

        results.each do |result|
          if result.valid_plan and (best == nil or result.score < best)
            best = result.score
          end
        end

        return best
      else
        return nil
      end
    else
      return nil
    end
  end
end
