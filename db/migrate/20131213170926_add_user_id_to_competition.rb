class AddUserIdToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :user_id, :integer
  end
end
