class AddPlainTextToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :plain_text, :text
  end
end
