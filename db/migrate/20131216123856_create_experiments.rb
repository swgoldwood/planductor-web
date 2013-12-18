class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.integer :competition_id
      t.integer :domain_id
      t.integer :problem_number

      t.timestamps
    end
  end
end
