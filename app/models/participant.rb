class Participant < ActiveRecord::Base
  attr_accessible :competition_id, :planner_id

  belongs_to :competition
  belongs_to :planner
end
