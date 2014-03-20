class Domain < ActiveRecord::Base
  attr_accessible :name, :user_id, :number_of_problems, :tarball, :status, :plain_text, :error_message

  has_attached_file :tarball

  has_many :problems, dependent: :destroy
  has_many :experiments
  belongs_to :user

  validates :name, presence: true
  validates :user_id, presence: true
  validates :tarball, attachment_presence: true
  validates_attachment_content_type :tarball, content_type: 'application/x-tar'

  after_initialize :init

  def status_string
    case self.status
      when 'pending'
        'Pending verification'
      when 'verified'
        'Successfully verified! Domain can be used in competitions.'
      when 'error'
        'There is a problem with domain uploaded.'
      else
        'Unknown status'
    end
  end

  private
    def init
      self.status ||= 'pending'
      self.number_of_problems ||= 0
    end
end
