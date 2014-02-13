class Problem < ActiveRecord::Base
  attr_accessible :domain_id, :name, :plain_text, :problem_number

  belongs_to :domain
end
