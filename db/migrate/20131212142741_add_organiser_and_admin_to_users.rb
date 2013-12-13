class AddOrganiserAndAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :organiser, :boolean
    add_column :users, :admin, :boolean
  end
end
