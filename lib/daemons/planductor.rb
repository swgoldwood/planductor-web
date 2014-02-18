#!/usr/bin/env ruby

# You might want to change this
#ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

$running = true
Signal.trap("TERM") do 
  $running = false
end

logger = Logger.new('log/planductor.log')

while($running) do
  
  # Replace this with your code
  logger.info "This daemon is still running at #{Time.now}.\n"

  tasks = Task.all

  tasks.each do |task|
    logger.info "task: #{task.id}"
  end
  
  sleep 30
end
