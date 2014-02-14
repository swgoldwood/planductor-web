class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :participant_id
      t.integer :experiment_id
      t.string :status

      t.timestamps
    end
  end
end
