class Task < ActiveRecord::Base
  attr_accessible :experiment_id, :participant_id, :status, :host_id, :output

  has_many :results, dependent: :destroy

  belongs_to :experiment
  belongs_to :participant
  belongs_to :host

  validates :experiment_id, presence: true
  validate :participant_id, presence: true
  validates_uniqueness_of :experiment_id, scope: :participant_id

  after_initialize :init

  def best_quality
    if self.results.any?
      best = nil

      results.each do |result|
        if result.valid_plan and (best == nil or result.quality < best)
          best = result.quality
        end
      end

      return best
    end

    nil
  end

  def assign(host_id)
    self.status = 'working'
    self.host_id = host_id
  end

  def unassign(status = 'pending')
    self.status = status
    self.host_id = nil
  end

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
