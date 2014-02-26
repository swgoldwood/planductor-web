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
  logger.info "Planductor daemon is still running at #{Time.now}.\n"

  #handling clients
  read_sockets, write_sockets, error_sockets = IO.select(client_sockets, nil, nil, 10)

  if read_sockets

    logger.info "read_sockets"

    read_sockets.each do |read_socket|
      if read_socket == server_socket
        client_socket = read_socket.accept
        ip_address = client_socket.addr[3]
        logger.info "new socket - IP Address: #{ip_address}" 

        host = Host.find_by_ip_address(ip_address)

        if host and host.trusted
          logger.info "New connection is trusted"
          client_sockets.push client_socket
        else
          logger.info "New connection is not trusted, closing socket"
          client_socket.close
        end
      else
        logger.info "handling existing client"

        msg = read_socket.recv(1048576)

        if msg.empty?
          logger.info "Empty message - closing client"
          read_socket.close
          client_sockets.delete(read_socket)
        else
          logger.info "MSG: #{msg}"

          msg_json = JSON.parse(msg)

          logger.info "status: #{msg_json['status']}"

          if msg_json['status'] == 'ready'
            logger.info "client is ready, checking for available task"

            if Task.available_tasks?
              task = Task.available_task
              host = Host.find_by_ip_address(read_socket.addr[3])

              task.status = "working"
              task.host_id = host.id
              #task.start_time = Time.now

              if task.save
                response = {
                  "status" => "ok",
                  "task_id" => task.id,
                  "dependencies" => {
                    "planner" => task.participant.planner.tarball.url,
                    "domain"  => task.experiment.domain.tarball.url,
                    "problem_number" => task.experiment.problem.problem_number
                  }
                }
                read_socket.send(response.to_json, 0)
              else
                logger.info "There has been an error when saving task"

                read_socket.close
                client_sockets.delete(read_socket)
              end
            else
              logger.info "No available task for host, closing socket"
              read_socket.send('No available task', 0)
              read_socket.close

              client_sockets.delete(read_socket)
            end
          elsif msg_json['status'] == 'complete'
            logger.info "Task is complete"
            # msg_json['results'].each do |result|
            # end
          elsif msg_json['status'] == 'error'
            logger.info("Error with client. Need to unassign task")
          end
        end
      end
    end
  else
    logger.info "Timed out"
  end

end
