#!/usr/bin/env ruby

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

client_sockets = []
server_socket = TCPServer.open(37123)

client_sockets.push(server_socket)

while($running) do
  logger.info "This daemon is still running at #{Time.now}.\n"

  #handling clients
  read_sockets, write_sockets, error_sockets = IO.select(client_sockets, nil, nil, 10)

  if read_sockets

    logger.info "read_sockets"

    read_sockets.each do |read_socket|
      if read_socket == server_socket
        client_socket = read_socket.accept
        ip_address = client_socket.addr[3]
        logger.info "new socket - IP Address: #{ip_address}" 
        client_sockets.push client_socket
      else
        logger.info "handling existing client"

        msg = read_socket.recv(1048576)

        if msg.empty?
          logger.info "Empty message - closing client"
          read_socket.close
          client_sockets.delete(read_socket)
        else
          logger.info "MSG: #{msg}"

          response = JSON.parse(msg)

          logger.info "status: #{response['status']}"

          if response['status'] == 'ready'
            if Task.available_tasks?
              read_socket.send(Task.available_task.to_json, 0)
            else
              read_socket.send('No available task', 0)
            end
          end
        end
      end
    end
  else
    logger.info "Timed out"
  end

  #check health for tasks
end
