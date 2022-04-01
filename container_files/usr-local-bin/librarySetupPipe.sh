#!/bin/bash

setupPipe() {
    echo "grouperContainer; INFO: (librarySetupPipe.sh-setupPipe) Setup pipe: $1"
    if [ -e $1 ]; then
        rm -f $1
        returnCode=$?
    fi
    mkfifo -m 666 $1
    returnCode=$?
}

setupPipe_logging() {

  if [ "$GROUPER_USE_PIPES" == "true" ]; then
    # Make a "console" logging pipe that anyone can write too regardless of who owns the process.
    setupPipe /tmp/logpipe
    cat <> /tmp/logpipe &
  fi
}

# Make loggers pipes for the supervisord connected apps' console, so that we can prepend the streams.
setupPipe_grouperLog() {
  if [ "$GROUPER_USE_PIPES" == "true" ]; then
    setupPipe /tmp/loggrouper
    (cat <> /tmp/loggrouper | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "grouper;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
  fi
}

setupPipe_httpdLog() {
  if [ "$GROUPER_USE_PIPES" == "true" ]; then
    if [ "$GROUPER_RUN_APACHE" = "true" ]
      then
        setupPipe /tmp/loghttpd
        (cat <> /tmp/loghttpd  | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "httpd;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
    fi
  fi
}

setupPipe_shibdLog() {
  if [ "$GROUPER_USE_PIPES" == "true" ]; then
    if [ "$GROUPER_RUN_SHIB_SP" = "true" ]
      then
        if [ "$GROUPER_SHIB_LOG_USE_PIPE" = "true" ]
          then
            setupPipe /tmp/logshibd
            (cat <> /tmp/logshibd | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "shibd;console;%s;%s;%s", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
        fi
    fi
  fi
}

setupPipe_tomcatLog() {
  if [ "$GROUPER_USE_PIPES" == "true" ]; then
    if [ "$GROUPER_RUN_TOMEE" = "true" ] && [ "$GROUPER_LOG_TO_HOST" != "true" ]
      then
        setupPipe /tmp/logtomcat
        (cat <> /tmp/logtomcat | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "tomee;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
    fi
  fi
}

setupPipe_tomcatAccessLog() {
  if [ "$GROUPER_USE_PIPES" == "true" ]; then
    if [ "$GROUPER_TOMCAT_LOG_ACCESS" = "true" ]; then
    
      setupPipe /tmp/tomcat_access_log
      (cat <> /tmp/tomcat_access_log | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "tomcat-access;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' 1>/tmp/logpipe) &
    fi
  fi
}

setupPipe_supervisordLog() {
  if [ "$GROUPER_USE_PIPES" == "true" ]; then
    setupPipe /tmp/logsuperd
    (cat <> /tmp/logsuperd | awk -v ENV="$ENV" -v UT="$USERTOKEN" '{printf "supervisord;console;%s;%s;%s\n", ENV, UT, $0; fflush()}' &>/tmp/logpipe) &
  fi
}

setupPipe_unsetAll() {

  unset -f setupPipe
  unset -f setupPipe_grouperLog
  unset -f setupPipe_httpdLog
  unset -f setupPipe_logging
  unset -f setupPipe_shibdLog
  unset -f setupPipe_supervisordLog
  unset -f setupPipe_tomcatLog
  unset -f setupPipe_tomcatAccessLog
  unset -f setupPipe_unsetAll

}

setupPipe_exportAll() {

  export -f setupPipe
  export -f setupPipe_grouperLog
  export -f setupPipe_httpdLog
  export -f setupPipe_logging
  export -f setupPipe_shibdLog
  export -f setupPipe_supervisordLog
  export -f setupPipe_tomcatLog
  export -f setupPipe_tomcatAccessLog
  export -f setupPipe_unsetAll

}

# export everything
setupPipe_exportAll

