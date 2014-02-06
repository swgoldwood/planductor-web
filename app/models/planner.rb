class Planner < ActiveRecord::Base
  attr_accessible :name, :user_id, :tarball

  has_attached_file :tarball

  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :competitions, through: :participants

  validates :user_id, presence: true
  validates :name, presence: true
  validates :tarball, :attachment_presence => true
  #validate :tarball_has_plan_file

  private

    # Validates that uploaded tar file has a plan file when extracted
    # The tarbal uploaded is extracted in temporary directory
    #   If a file called 'plan' exists, validation will succeed
    #   else, the planner does not meet specification
    def tarball_has_plan_file
      tarball.save
      temp_dir = "/tmp/#{name}"
      out_temp_dir = temp_dir + '/out'

      FileUtils.mkdir_p(temp_dir)
      FileUtils.mkdir_p(out_temp_dir)
      FileUtils.cp(tarball.path, temp_dir)

      system_call = "tar xf #{temp_dir}/#{tarball.original_filename} -C #{out_temp_dir}" 
      logger.info("EXECUTING SYSTEM CALL: #{system_call}")
      system(system_call)

      unless File.exists?("#{out_temp_dir}/plan")
        errors.add(:tarball, "Input tarball has no plan file")
      end

      FileUtils.rm_rf(temp_dir)
    end
end
