#!/bin/bash

runCommand() {

  echo "grouperContainer; INFO: (libraryRunCommand.sh-runCommand) Start setting up remaining pipes"
  setupPipe_httpdLog
  setupPipe_shibdLog
  setupPipe_tomcatLog
  setupPipe_tomcatAccessLog
  echo "grouperContainer; INFO: (libraryRunCommand.sh-runCommand) End setting up remainder pipes"

  runCommand_unsetAll
  
  if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" = "true" ]
    then
      echo "grouperContainer; INFO: (libraryRunCommand.sh-runCommand) Starting tomcat not supervisor"
      /opt/tomee/bin/catalina.sh run
    else
      echo "grouperContainer; INFO: (libraryRunCommand.sh-runCommand) Starting supervisor"
      exec /usr/bin/supervisord -c /opt/tier-support/supervisord.conf
  fi

}

runCommand_unsetAll() {
  setupPipe_unsetAll
  unset -f runCommand
  unset -f runCommand_unsetAll
}

runCommand_exportAll() {
  export -f runCommand
  export -f runCommand_unsetAll
  
}

# export everything
runCommand_exportAll

