class Competition < ActiveRecord::Base
  attr_accessible :description, :name, :user_id

  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :planners, through: :participants

  validates :name, presence: true, length: { minimum: 10, maximum: 80 }, uniqueness: true
  validates :description, presence: true, length: { minimum: 50 }
  #validates :user_id, presence: true

  def participant?(planner)
    participants.find_by_planner_id(planner.id)
  end

  def participate!(planner)
    participants.create!(planner_id: planner.id)
  end

  def unparticipate!(planner)
    participants.find_by_planner_id(planner.id).destroy
  end
end
