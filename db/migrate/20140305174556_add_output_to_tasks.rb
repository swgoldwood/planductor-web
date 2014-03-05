class AddOutputToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :output, :text
  end
end
