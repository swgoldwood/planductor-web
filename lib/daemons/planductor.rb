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

#set any previously working tasks are now pending
logger.info "Setting all previously working tasks to pending state"

Task.all.each do |task|
  if task.status == 'working'
    task.status = 'pending'
  end
  task.host_id = nil
  task.save!
end

while($running) do
  logger.info "Planductor daemon is still running at #{Time.now}.\n"

  #handling clients
  read_sockets, write_sockets, error_sockets = IO.select(client_sockets, nil, nil, 10)

  if read_sockets

    logger.info "handling socket"

    read_sockets.each do |read_socket|
      if read_socket == server_socket
        client_socket = read_socket.accept
        sock_domain, remote_port, remote_hostname, remote_ip = client_socket.peeraddr

        logger.info "new socket with IP address: #{remote_ip}" 

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
          logger.info "Empty message - checking if socket has been assigned a task"
          sock_domain, remote_port, remote_hostname, remote_ip = read_socket.peeraddr

          host = Host.find_by_ip_address(remote_ip)
          task = Task.find_by_host_id(host.id)

          if task
            logger.info "Unassigning task from host"
            task.unassign
            task.save
          else
            logger.info "No task to unassign for disconnected host"
          end

          read_socket.close
          client_sockets.delete(read_socket)
        else
          logger.info "MSG: #{msg}"

          msg_json = JSON.parse(msg)

          if msg_json['status'] == 'ready'
            logger.info "client is ready, checking for available task"

            if Task.available_tasks?
              sock_domain, remote_port, remote_hostname, remote_ip = read_socket.peeraddr

              host = Host.find_by_ip_address(remote_ip)

              if host.task
                logger.error "host #{remote_ip} already has task assigned"
              else
                task = Task.available_task

                task.assign(host.id)

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

              msg_json['task']['results'].each do |r|
                result = task.results.build
                result.result_number = r['result_number']
                result.quality = r['quality']
                result.output = r['output']
                result.valid_plan = r['valid_plan']
                result.validation_output = r['validation_output']

                result.save
              end

              task.output = msg_json['task']['output']
              task.unassign('complete')
              task.save

              read_socket.send({"status" => "ok"}.to_json, 0)
            end
          elsif msg_json['status'] == 'error'
            logger.info("Error with client. Need to unassign task")
          end
        end
      end
    end
  end

end
