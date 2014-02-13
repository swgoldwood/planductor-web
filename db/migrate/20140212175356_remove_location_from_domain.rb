class RemoveLocationFromDomain < ActiveRecord::Migration
  def up
    remove_column :domains, :location
  end

  def down
    add_column :domains, :location, :string
  end
end
