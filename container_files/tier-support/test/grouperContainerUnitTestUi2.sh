#!/bin/bash

testContainerUi2() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_TOMCAT_MAX_HEADER_COUNT=1235 -e GROUPER_SSL_USE_STAPLING=false -e GROUPER_SSL_CERT_FILE=/a/b/cert -e GROUPER_SSL_KEY_FILE=/a/b/key -e GROUPER_SSL_CHAIN_FILE=/a/b/chain -e GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER=false -e GROUPER_APACHE_STATUS_PATH=none $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_TOMCAT_MAX_HEADER_COUNT=1235 -e GROUPER_SSL_USE_STAPLING=false -e GROUPER_SSL_CERT_FILE=/a/b/cert -e GROUPER_SSL_KEY_FILE=/a/b/key -e GROUPER_SSL_CHAIN_FILE=/a/b/chain -e GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER=false -e GROUPER_APACHE_STATUS_PATH=none $imageName ui
  sleep $globalSleepSecondsAfterRun


  assertFileContains /opt/tomee/conf/server.xml 'address="0.0.0.0"'
  assertFileContains /opt/tomee/conf/server.xml 'allowedRequestAttributesPattern=".*"'
  
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libWs/axis2-kernel-1.6.4.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libScim/stax-api-1.0-2.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/stax-api-1.0-2.jar
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/lib/grouper-messaging-activemq-$grouperVersion.jar"
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/grouper-messaging-activemq-$grouperVersion.jar"

  assertFileContains /etc/httpd/conf/httpd.conf "Listen 80"
  assertFileContains /opt/tier-support/supervisord.conf "program:shibbolethsp"
  assertFileContains /opt/tier-support/supervisord.conf "program:tomee"
  assertFileContains /opt/tier-support/supervisord.conf "program:httpd"
  assertFileContains /opt/tier-support/supervisord.conf "user=shibd"
  assertFileNotContains /opt/tier-support/supervisord.conf "__"

  assertFileContains /opt/tomee/conf/server.xml "maxHeaderCount"
  assertFileContains /opt/tomee/conf/server.xml "1235"

  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "SSLUseStapling off"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "SSLCertificateFile /a/b/cert"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "SSLCertificateKeyFile /a/b/key"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "SSLCertificateChainFile /a/b/chain"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "Listen 443 https"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "#RewriteRule"
  assertFileContains /etc/httpd/conf.d/grouper-www.conf "#RewriteRule"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "grouper/status"
  
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf "__"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf cachain.pem
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf /etc/pki/tls/certs/localhost.crt
  assertEnvVar GROUPER_SSL_USE_CHAIN_FILE "true"
  assertEnvVar GROUPER_SSL_CERT_FILE "/a/b/cert"
  assertEnvVar GROUPER_SSL_KEY_FILE "/a/b/key"
  assertEnvVar GROUPER_SSL_CHAIN_FILE "/a/b/chain"
  assertEnvVar GROUPER_SSL_USE_STAPLING "false"

  assertNumberOfTomcatProcesses 1
  # bad cert apache wont start
  assertNumberOfApacheProcesses 0
  assertNumberOfShibProcesses 1

  assertNotListeningOnPort 443
  assertNotListeningOnPort 80
  assertListeningOnPort 8009
  assertNotListeningOnPort 9001
  assertListeningOnPort 8080
  #assertListeningOnPort 8005


}
export -f testContainerUi2
