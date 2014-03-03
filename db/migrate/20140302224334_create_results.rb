class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :result_number
      t.integer :score
      t.text :output
      t.text :validation_output
      t.integer :task_id

      t.timestamps
    end
  end
end
