class Participant < ActiveRecord::Base
  attr_accessible :competition_id, :planner_id

  belongs_to :competition
  belongs_to :planner

  validates :competition_id, presence: :true
  validates :planner_id, presence: true
end
