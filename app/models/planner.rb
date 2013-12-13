class Planner < ActiveRecord::Base
  attr_accessible :location, :name, :user_id

  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :competitions, through: :participants
end
