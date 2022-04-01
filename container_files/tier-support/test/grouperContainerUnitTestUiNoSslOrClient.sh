#!/bin/bash

testContainerUiNoSslOrClient() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui without SSL with non-SSL client
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_USE_SSL=false -e GROUPER_WEBCLIENT_IS_SSL=false $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_USE_SSL=false -e GROUPER_WEBCLIENT_IS_SSL=false $imageName ui
  sleep $globalSleepSecondsAfterRun

  assertFileExists /etc/httpd/conf.d/ssl-enabled.conf.dontuse
  assertFileExists /etc/httpd/conf.d/ssl.conf.dontuse
  assertFileNotExists /etc/httpd/conf.d/ssl-enabled.conf
  assertFileNotExists /etc/httpd/conf.d/ssl.conf

  assertFileNotContains /opt/tomee/conf/server.xml 'secure="true"'
  assertFileNotContains /opt/tomee/conf/server.xml 'scheme="https"'
  assertFileContains /opt/tomee/conf/server.xml 'scheme="http"'

  assertEnvVar GROUPER_USE_SSL "false"
  assertEnvVar GROUPER_WEBCLIENT_IS_SSL "false"
  

  assertNumberOfTomcatProcesses 1
  assertNumberOfApacheProcesses 5
  assertNumberOfShibProcesses 1

  assertNotListeningOnPort 443
  assertListeningOnPort 80
  assertListeningOnPort 8009
  assertNotListeningOnPort 9001


}
export -f testContainerUiNoSsl
