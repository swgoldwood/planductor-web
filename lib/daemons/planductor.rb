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
        sock_domain, remote_port, remote_hostname, remote_ip = client_socket.peeraddr

        logger.info "new socket - IP Address: #{remote_ip}" 

        host = Host.find_by_ip_address(remote_ip)

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
              sock_domain, remote_port, remote_hostname, remote_ip = read_socket.peeraddr

              task = Task.available_task
              host = Host.find_by_ip_address(remote_ip)

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
              read_socket.send({"status" => "ok", "task_id" => nil}.to_json, 0)
              read_socket.close

              client_sockets.delete(read_socket)
            end
          elsif msg_json['status'] == 'complete'
            logger.info "Task is complete"
            sock_domain, remote_port, remote_hostname, remote_ip = read_socket.peeraddr

            host = Host.find_by_ip_address(remote_ip)
            task = host.task

            if not task
              logger.info "Host doesn't have task assigned, ignoring results and closing socket"
              read_socket.close
              client_sockets.delete(read_socket)
            else
              logger.info "Host returned results"
              logger.info msg_json.to_json

              task.status = "complete"
              task.host_id = nil
              task.save

              read_socket.send({"status" => "ok"}.to_json, 0)
            end
            
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
