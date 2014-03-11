class AddCpuTimeToExperiment < ActiveRecord::Migration
  def change
    add_column :experiments, :cpu_time, :integer
  end
end
