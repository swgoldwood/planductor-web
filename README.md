planductor-web
==============
Web and server application for AI Planning competitions.

Prerequisites:
 - Server running recent Ubuntu operating system (Should work in other main distributions but this has not been tested)
 - Ruby version 1.9.3 or above but below version 2.0 (Install using rvm: ``rvm install 1.9.3'')
 - Redis-server installed and running on default port (Install with apt-get: ``sudo apt-get install redis-server'')
 - Javascript runtime environment (Install nodejs with apt-get: ``sudo apt-get install nodejs'')

###

Steps for setting up Planductor-web:

1. To set up the web interface, open a terminal session and navigate to planductor-web source directory. Run the bundle command to install all the Rails dependencies:

        bundle install

This will install all the dependencies referenced in the Gemfile.

2. Next, migrate the database with this command:

        rake db:migrate

This will create all the tables and constraints defined in the db/schema.rb file.  There may be an error message complaining about a lack of javascript runtime environment. If so, install nodejs through apt-get and retry.

3. Prepare the test database with this command:

        rake db:test:prepare

4. Run the tests to confirm everything is in working order:

        rspec

5. If all the tests pass then the environment is good. Firstly, we need to start the resque workers, which do background processing for domain and planner uploads:

        QUEUE=* rake resque:work &

6. To start Planductor-web run this command:

        rails server

This sets up the web server on port 3000.

###

Steps for setting up Planductor-server:

1. Open a new terminal session and navigate to the planductor-web directory again. Create a self-signed certificate for the SSL server. Run this command:

        openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout config/server.key -out config/server.crt

2. To start the server daemon, run this command:

        rake daemon:planductor:start

3. Confirm daemon is running:

        rake daemon:planductor:status
