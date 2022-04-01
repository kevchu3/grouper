#!/bin/bash

testContainerUiDifferentPorts() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui with self signed cert with different ports
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_APACHE_AJP_TIMEOUT_SECONDS=2999 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_APACHE_SSL_PORT=444 -e GROUPER_APACHE_NONSSL_PORT=81 -e GROUPER_TOMCAT_HTTP_PORT=8600 -e GROUPER_TOMCAT_AJP_PORT=8601 -e GROUPER_TOMCAT_SHUTDOWN_PORT=8602 -e GROUPER_APACHE_STATUS_PATH=/status2_grouper/status $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_APACHE_AJP_TIMEOUT_SECONDS=2999 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_APACHE_SSL_PORT=444 -e GROUPER_APACHE_NONSSL_PORT=81 -e GROUPER_TOMCAT_HTTP_PORT=8600 -e GROUPER_TOMCAT_AJP_PORT=8601 -e GROUPER_TOMCAT_SHUTDOWN_PORT=8602 -e GROUPER_APACHE_STATUS_PATH=/status2_grouper/status $imageName ui
  sleep $globalSleepSecondsAfterRun

  assertEnvVar GROUPER_APACHE_NONSSL_PORT "81"
  assertEnvVar GROUPER_APACHE_SSL_PORT "444"
  assertEnvVar GROUPER_APACHE_AJP_TIMEOUT_SECONDS "2999"

  assertEnvVar GROUPER_TOMCAT_HTTP_PORT "8600"
  assertEnvVar GROUPER_TOMCAT_AJP_PORT "8601"
  assertEnvVar GROUPER_TOMCAT_SHUTDOWN_PORT "8602"

  assertFileContains /etc/httpd/conf.d/grouper-www.conf "2999"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "3600"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "2400"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "__"
  assertFileContains /etc/httpd/conf.d/grouper-www.conf "ProxyPass /status2_grouper/status ajp://localhost:8601/grouper/status timeout=2401"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf "Listen 443 https"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "Listen 444 https"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf "__"
  assertFileNotContains /etc/httpd/conf/httpd.conf "Listen 80"
  assertFileContains /etc/httpd/conf/httpd.conf "Listen 81"

  assertNumberOfTomcatProcesses 1
  # bad cert apache wont start
  assertNumberOfApacheProcesses 5
  assertNumberOfShibProcesses 1

  assertListeningOnPort 444
  assertListeningOnPort 81
  assertNotListeningOnPort 443
  assertNotListeningOnPort 80
  assertListeningOnPort 8600
  assertListeningOnPort 8601
  #assertListeningOnPort 8602
  assertNotListeningOnPort 9001


}
export -f testContainerUiDifferentPorts
