class AddErrorMessageToPlanner < ActiveRecord::Migration
  def change
    add_column :planners, :error_message, :string
  end
end
