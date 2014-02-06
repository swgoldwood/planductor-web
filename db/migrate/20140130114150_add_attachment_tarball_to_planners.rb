class AddAttachmentTarballToPlanners < ActiveRecord::Migration
  def self.up
    change_table :planners do |t|
      t.attachment :tarball
    end
  end

  def self.down
    drop_attached_file :planners, :tarball
  end
end
