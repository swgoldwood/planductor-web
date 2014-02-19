class AddHostIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :host_id, :integer
  end
end
