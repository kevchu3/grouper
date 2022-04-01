#!/bin/bash

dockerRemoveContainer() {
  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 arguments"
    exit 1
  fi
  if [ "$(docker ps -a | grep $containerName)" ]
    then
      docker rm -f $containerName
  fi
}

dockerRemoveSubimage() {
  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 arguments"
    exit 1
  fi
  subimageId="my_$containerName"
  subimageName="$subimageId:latest"
  if [ "$(docker images | grep $subimageId)" ]
    then
      docker rmi -f $subimageName
  fi
}

# pass in string description, expected value, actual value
assertEquals() {
  if [ "$#" -ne 3 ]; then
    echo "You must enter exactly 3 arguments: statement, expected value, actual value"
    exit 1
  fi

  if [ "$2" != "$3" ]
    then
      echo "ERROR: $1: expected '$2' but received '$3'"
      if [ "$globalExitOnError" = "true" ]; then
        exit 1
      fi
      export failureCount=$((failureCount+1))
    else
      echo "SUCCESS: $1: $2"
      export successCount=$((successCount+1))
  fi
}

# pass in string description, expected value, actual value it should not be
assertNotEquals() {
  if [ "$#" -ne 3 ]; then
    echo "You must enter exactly 3 arguments: statement, expected value, actual value it should not be"
    exit 1
  fi

  if [ "$2" = "$3" ]
    then
      echo "ERROR: $1: expected '$2' to not equals '$3' but was equal"
      if [ "$globalExitOnError" = "true" ]; then
        exit 1
      fi
      export failureCount=$((failureCount+1))
    else
      echo "SUCCESS: $1: not equal to: '$2', is: '$3'"
      export successCount=$((successCount+1))
  fi
}

# pass in string description, first value, less than second valuee
assertLessThan() {
  if [ "$#" -ne 3 ]; then
    echo "You must enter exactly 3 arguments: statement, first value, second value"
    exit 1
  fi

  if [ "$2" -ge "$3" ]
    then
      echo "ERROR: $1: expecting '$2' < '$3'"
      if [ "$globalExitOnError" = "true" ]; then
        exit 1
      fi
      export failureCount=$((failureCount+1))
    else
      echo "SUCCESS: $1: '$2' < '$3'"
      export successCount=$((successCount+1))
  fi
}

# pass in file name, value
assertFileContains() {
  if [ "$#" -ne 2 ]; then
    echo "You must enter exactly 2 arguments: file name, and value"
    exit 1
  fi

  local command="docker exec -it $containerName grep '$2' $1 | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertLessThan "file $1 should contain at least one '$2'" "0" "$var"
}

# pass in file name, value
assertLocalFileContains() {
  if [ "$#" -ne 2 ]; then
    echo "You must enter exactly 2 arguments: file name, and value"
    exit 1
  fi

  local command="grep '$2' $1 | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertLessThan "file $1 should contain at least one '$2'" "0" "$var"
}

assertFileNotContains() {
  if [ "$#" -ne 2 ]; then
    echo "You must enter exactly 2 arguments: file name, and value"
    exit 1
  fi

  local command="docker exec -it $containerName grep '$2' $1 | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertEquals "file $1 should not contain '$2'" "0" "$var"
}

assertFileExists() {
  if [ "$#" -ne 1 ]; then
    # generally 0 or 5 processes
    echo "You must enter exactly 1 arguments: file to check"
    exit 1
  fi
  local command="docker exec -it $containerName grouperTestFileExist.sh $1 | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertEquals "file $1 should exist" "1" "$var"
}

assertFileNotExists() {
  if [ "$#" -ne 1 ]; then
    # generally 0 or 5 processes
    echo "You must enter exactly 1 arguments: file to check"
    exit 1
  fi
  local command="docker exec -it $containerName grouperTestFileExist.sh $1 | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertEquals "file $1 should not exist" "0" "$var"
}

assertListeningOnPort() {
  if [ "$#" -ne 1 ]; then
    echo "You must enter exactly 1 argument: port"
    exit 1
  fi

  local command="docker exec -it $containerName netstat -pan | grep LISTEN | grep ':$1 ' | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertEquals "listening on port $1" "1" "$var"
}

assertNotListeningOnPort() {
  if [ "$#" -ne 1 ]; then
    echo "You must enter exactly 1 argument: port"
    exit 1
  fi

  local command="docker exec -it $containerName netstat -pan | grep LISTEN | grep ':$1 ' | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertEquals "not listening on port $1" "0" "$var"
}

containerCommandResultEquals() {

  if [ "$#" -ne 2 ]; then
    echo "You must enter exactly 2 arguments: the command to run and the expected result"
    exit 1
  fi
  local command="docker exec $containerName $1"
  local var="$(runCommand "$command")"
  assertEquals "$1" "$2" "$var"

}

runCommand() {
  if [ "$#" -ne 1 ]; then
    echo "Pass the command to run"
    exit 1
  fi
  local command=$1
  local var=$(eval "$command")
  # for some reason sometimes whitespace is there
  local var=$(echo -e "${var}" | tr -d '\r' | tr -d '\n')
  echo $var
}

assertNumberOfTomcatProcesses() {
  if [ "$#" -ne 1 ]; then
    echo "You must enter exactly 1 arguments: the number of tomcat processes"
    exit 1
  fi
  local command="docker exec -it $containerName ps -ef | grep "^tomcat" | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertEquals "tomcat process count" "$1" "$var"
}

assertNumberOfApacheProcesses() {
  if [ "$#" -ne 1 ]; then
    # generally 0 or 5 processes
    echo "You must enter exactly 1 arguments: the number of apache processes"
    exit 1
  fi
  local command="docker exec -it $containerName ps -ef | grep "^apache" | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertEquals "apache process count" "$1" "$var"
}

assertNumberOfShibProcesses() {
  if [ "$#" -ne 1 ]; then
    # generally 0 or 5 processes
    echo "You must enter exactly 1 arguments: the number of shib processes"
    exit 1
  fi
  local command="docker exec -it $containerName ps -ef | grep "^shibd" | wc -l | xargs"
  local var="$(runCommand "$command")"
  assertEquals "shib process count" "$1" "$var"
}

assertEnvVar() {
  if [ "$#" -ne 2 ]; then
    echo "You must enter exactly 2 arguments: the env var name and value"
    exit 1
  fi
  local command="docker exec -it --user tomcat $containerName grouperTestPrintEnv.sh $1 | xargs"
  local var="$(runCommand "$command")"
  assertEquals "env var $1" "$2" "$var"
}

assertEnvVarNot() {
  if [ "$#" -ne 2 ]; then
    echo "You must enter exactly 2 arguments: the env var name and value"
    exit 1
  fi
  local command="docker exec -it --user tomcat $containerName grouperTestPrintEnv.sh $1 | xargs"
  local var="$(runCommand "$command")"
  assertNotEquals "env var $1" "$2" "$var"
}

grouperContainerUnitTestLibrary_unsetAll() {
  unset -f assertEnvVar
  unset -f assertEnvVarNot
  unset -f assertEquals
  unset -f assertFileContains
  unset -f assertFileExists
  unset -f assertFileNotContains
  unset -f assertFileNotExists
  unset -f assertLessThan
  unset -f assertListeningOnPort
  unset -f assertNotEquals
  unset -f assertNotListeningOnPort
  unset -f assertNumberOfApacheProcesses
  unset -f assertNumberOfShibProcesses
  unset -f assertNumberOfTomcatProcesses
  unset -f dockerRemoveContainer
  unset -f dockerRemoveSubimage
  unset -f grouperContainerUnitTestLibrary_unsetAll
  unset -f runCommand
}

grouperContainerUnitTestLibrary_exportAll() {
  export -f assertEnvVar
  export -f assertEnvVarNot
  export -f assertEquals
  export -f assertFileContains
  export -f assertFileExists
  export -f assertFileNotContains
  export -f assertFileNotExists
  export -f assertLessThan
  export -f assertListeningOnPort
  export -f assertNotEquals
  export -f assertNotListeningOnPort
  export -f assertNumberOfApacheProcesses
  export -f assertNumberOfShibProcesses
  export -f assertNumberOfTomcatProcesses
  export -f dockerRemoveContainer
  export -f dockerRemoveSubimage
  export -f grouperContainerUnitTestLibrary_unsetAll
  export -f runCommand
}

# export everything
grouperContainerUnitTestLibrary_exportAll
