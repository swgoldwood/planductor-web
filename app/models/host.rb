class Host < ActiveRecord::Base
  attr_accessible :ip_address, :trusted

  validates_presence_of :ip_address
end
