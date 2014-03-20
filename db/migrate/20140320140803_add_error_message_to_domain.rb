class AddErrorMessageToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :error_message, :string
  end
end
