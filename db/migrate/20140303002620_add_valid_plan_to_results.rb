class AddValidPlanToResults < ActiveRecord::Migration
  def change
    add_column :results, :valid_plan, :boolean
  end
end
