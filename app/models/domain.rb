class Domain < ActiveRecord::Base
  attr_accessible :location, :name, :user_id, :number_of_problems
end
