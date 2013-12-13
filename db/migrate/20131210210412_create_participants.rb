class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :competition_id
      t.integer :planner_id

      t.timestamps
    end
  end
end
