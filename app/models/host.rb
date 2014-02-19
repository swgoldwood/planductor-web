class Host < ActiveRecord::Base
  attr_accessible :ip_address, :trusted

  has_one :task

  validates_presence_of :ip_address
end
