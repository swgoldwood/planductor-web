class ValidatePlanner
  @queue = :tarball_queue

  def self.perform(planner_id)
      logger = Logger.new('log/validate_planner_resque.log')

      planner = Planner.find(planner_id)

      temp_dir = "/tmp/#{name}_#{(0...8).map { (65 + rand(26)).chr }.join}"
      out_temp_dir = temp_dir + '/out'

      logger.info("Temp dir: #{temp_dir}, Out dir: #{out_temp_dir}")

      FileUtils.mkdir_p(temp_dir)
      FileUtils.mkdir_p(out_temp_dir)
      FileUtils.cp(planner.tarball.path, temp_dir)

      system_call = "tar xf '#{temp_dir}/#{planner.tarball.original_filename}' -C '#{out_temp_dir}'" 
      system(system_call)

      if File.exists?("#{out_temp_dir}/plan")
        planner.status = "verified"
      else
        planner.status = "error"
      end

      planner.save!

      FileUtils.rm_rf(temp_dir)
  end
end
