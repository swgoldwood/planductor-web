class Experiment < ActiveRecord::Base
  attr_accessible :competition_id, :domain_id, :problem_number

  validates :competition_id, presence: true
  validates :domain_id, presence: true
  validates :problem_number, presence: true, numericality: { only_integer: true }

  belongs_to :competition
  belongs_to :domain
end
