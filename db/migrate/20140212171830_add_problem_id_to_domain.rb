class AddProblemIdToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :problem_id, :integer
  end
end
