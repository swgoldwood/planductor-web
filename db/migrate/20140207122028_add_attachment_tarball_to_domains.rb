class AddAttachmentTarballToDomains < ActiveRecord::Migration
  def self.up
    change_table :domains do |t|
      t.attachment :tarball
    end
  end

  def self.down
    drop_attached_file :domains, :tarball
  end
end
