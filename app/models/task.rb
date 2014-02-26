class Task < ActiveRecord::Base
  attr_accessible :experiment_id, :participant_id, :status, :host_id

  belongs_to :experiment
  belongs_to :participant
  belongs_to :host

  validates :experiment_id, presence: true
  validate :participant_id, presence: true
  validates_uniqueness_of :experiment_id, scope: :participant_id

  after_initialize :init

  def self.available_tasks?
    where(status: 'pending').any?
  end

  def self.available_task
    where(status: 'pending').order("created_at ASC").first
  end

  private
    def init
      self.status ||= 'pending'
    end
end
