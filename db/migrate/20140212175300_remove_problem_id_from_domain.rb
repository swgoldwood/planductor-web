class RemoveProblemIdFromDomain < ActiveRecord::Migration
  def up
    remove_column :domains, :problem_id
  end

  def down
    add_column :domains, :problem_id, :integer
  end
end
