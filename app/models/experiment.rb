class Experiment < ActiveRecord::Base
  attr_accessible :competition_id, :domain_id, :problem_id

  validates :competition_id, presence: true
  validates :domain_id, presence: true
  validates :problem_id, presence: true

  belongs_to :competition
  belongs_to :domain
  belongs_to :problem
end
