class Result < ActiveRecord::Base
  attr_accessible :output, :result_number, :score, :task_id, :validation_output, :valid_plan

  belongs_to :task
end
