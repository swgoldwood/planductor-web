class Task < ActiveRecord::Base
  attr_accessible :experiment_id, :participant_id, :status

  belongs_to :experiment
  belongs_to :planner

  validates :experiment_id, presence: true
  validate :participant_id, presence: true
  validates_uniqueness_of :experiment_id, scope: :participant_id

  after_initialize :init

  private
    def init
      self.status ||= 'pending'
    end
end
