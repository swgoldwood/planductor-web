class RemoveProblemNumberFromExperiment < ActiveRecord::Migration
  def up
    remove_column :experiments, :problem_number
  end

  def down
    add_column :experiments, :problem_number, :integer
  end
end
