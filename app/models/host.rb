class Host < ActiveRecord::Base
  attr_accessible :ip_address, :trusted

  has_many :task

  validates_presence_of :ip_address
end
