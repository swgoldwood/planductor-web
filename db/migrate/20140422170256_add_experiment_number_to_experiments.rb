class AddExperimentNumberToExperiments < ActiveRecord::Migration
  def change
    add_column :experiments, :experiment_number, :integer
  end
end
