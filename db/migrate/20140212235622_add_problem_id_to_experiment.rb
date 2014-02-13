class AddProblemIdToExperiment < ActiveRecord::Migration
  def change
    add_column :experiments, :problem_id, :integer
  end
end
