class Participant < ActiveRecord::Base
  attr_accessible :competition_id, :planner_id

  has_many :tasks, dependent: :destroy

  belongs_to :competition
  belongs_to :planner

  validates :competition_id, presence: :true
  validates :planner_id, presence: true
  validates_uniqueness_of :competition_id, scope: :planner_id
end
