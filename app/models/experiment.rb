class Experiment < ActiveRecord::Base
  attr_accessible :competition_id, :domain_id, :problem_id

  has_many :tasks

  validates :competition_id, presence: true
  validates :domain_id, presence: true
  validates :problem_id, presence: true

  belongs_to :competition
  belongs_to :domain
  belongs_to :problem

  def best_quality
    quality = nil
    self.tasks.each do |task|
      task.results.each do |result|
        if result.valid_plan and (quality == nil or result.score < quality)
          quality = result.score
        end
      end
    end

    quality
  end
end
