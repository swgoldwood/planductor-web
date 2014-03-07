class RenameScoreToQualityForResult < ActiveRecord::Migration
  def up
    rename_column :results, :score, :quality
  end

  def down
  end
end
