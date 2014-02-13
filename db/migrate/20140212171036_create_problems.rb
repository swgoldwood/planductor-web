class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :name
      t.integer :problem_number
      t.text :plain_text

      t.timestamps
    end
  end
end
