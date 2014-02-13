class AddDomainIdToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :domain_id, :integer
  end
end
