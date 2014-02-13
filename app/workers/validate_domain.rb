class ValidateDomain < ValidateBase
  @queue = :tarball_queue

  def self.perform(domain_id)
    logger = Logger.new('log/validate_domain_resque.log')

    domain = Domain.find_by_id(domain_id)

    temp_dir = "/tmp/#{name}_#{(0...8).map { (65 + rand(26)).chr }.join}"
    out_temp_dir = temp_dir + '/out'

    logger.info("Temp directory: #{temp_dir}")

    FileUtils.mkdir_p(temp_dir)
    FileUtils.mkdir_p(out_temp_dir)
    FileUtils.cp(domain.tarball.path, temp_dir)
    
    system_call = "tar xf '#{temp_dir}/#{domain.tarball.original_filename}' -C '#{out_temp_dir}'" 
    system(system_call)

    domain_location = "#{out_temp_dir}/domain.pddl" 

    if File.exists?(domain_location)
      plain_text = File.read(domain_location)
      domain.plain_text = plain_text
    else 
      domain.status = 'error'
      domain.save!
      FileUtils.rm_rf(temp_dir)
      return
    end

    domain_files = Dir.entries(out_temp_dir)

    number_of_problems = 0
    while number_of_problems < 100 do
      found_match = false

      domain_files.each do |file|
        if file =~ /^pfile(\d\d).pddl$/
          if $1.to_i == number_of_problems + 1
            logger.info('found match: ' + file + ' num: ' + $1)
            number_of_problems += 1
            found_match = true

            problem = domain.problems.build
            problem.name = "pfile#{$1}.pddl"
            problem.problem_number = $1.to_i
            problem.plain_text = File.read("#{out_temp_dir}/#{problem.name}")

            problem.save!

            break
          end
        end
      end

      unless found_match
        break
      end
    end

    domain.number_of_problems = number_of_problems

    if number_of_problems > 0
      domain.status = 'verified'
    else
      domain.status = 'error'
    end

    domain.save!

    FileUtils.rm_rf(temp_dir)
  end
end
