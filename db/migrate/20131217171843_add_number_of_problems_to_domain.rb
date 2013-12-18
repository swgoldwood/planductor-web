class AddNumberOfProblemsToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :number_of_problems, :integer
  end
end
