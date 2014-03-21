planductor-web
==============
Web application for AI Planning competitions.

Start the resque worker
QUEUE=* rake resque:work

Start the planductor daemon
rake daemon:planductor:start
