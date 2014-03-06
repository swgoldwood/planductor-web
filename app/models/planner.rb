class Planner < ActiveRecord::Base
  attr_accessible :name, :user_id, :tarball

  has_attached_file :tarball

  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :competitions, through: :participants

  validates :user_id, :name, presence: true
  validates :name, length: { minimum: 3, maximum: 12 }
  validates :tarball, attachment_presence: true
  validates_attachment_content_type :tarball, content_type: 'application/x-tar'

  after_initialize :init

  def status_string
    case self.status
      when 'pending'
        'Pending verification'
      when 'verified'
        'Successfully verified! Planner can be used in competitions.'
      when 'error'
        'There is a problem with planner uploaded. Please check documentation here'
      else
        'Unknown status'
    end
  end

  private
    def init
      self.status ||= 'pending'
    end
end
