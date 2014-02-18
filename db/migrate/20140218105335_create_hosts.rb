class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :ip_address
      t.boolean :trusted

      t.timestamps
    end
  end
end
