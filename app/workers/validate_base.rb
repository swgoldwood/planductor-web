class ValidateBase
  def create_random_tmp(name)
    "/tmp/#{name}_#{(0...8).map { (65 + rand(26)).chr }.join}"
  end
end
