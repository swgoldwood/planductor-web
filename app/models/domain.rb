class Domain < ActiveRecord::Base
  attr_accessible :name, :user_id, :number_of_problems, :tarball, :status

  has_attached_file :tarball

  belongs_to :user

  validates :name, presence: true
  validates :user_id, presence: true
  validates :tarball, attachment_presence: true
  validates_attachment_content_type :tarball, content_type: 'application/x-tar'

  after_initialize :init

  private
    def init
      self.status ||= 'pending'
    end
end
