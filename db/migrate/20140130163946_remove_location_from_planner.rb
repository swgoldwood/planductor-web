class RemoveLocationFromPlanner < ActiveRecord::Migration
  def up
    remove_column :planners, :location
  end

  def down
    add_column :planners, :location, :string
  end
end
