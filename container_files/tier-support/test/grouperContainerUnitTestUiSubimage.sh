#!/bin/bash

testContainerUiSubimage() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer
  dockerRemoveSubimage

  subimageId="my_$containerName"
  subimageName="$subimageId:latest"

  echo "" > Dockerfile
  echo "FROM $imageName" >> Dockerfile
  echo "ENV GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES 1.1.1.1/32" >> Dockerfile
  echo "" >> Dockerfile

  echo
  echo '################'
  echo Running container with subimage as ui
  echo cat DockerFile
  cat Dockerfile
  echo "docker build -t $subimageId ."
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_SSL_CERT_FILE=/etc/pki/tls/certs/host-cert.pem $subimageId ui"
  echo '################'
  echo

  docker build -t "$subimageId" .

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_SSL_CERT_FILE=/etc/pki/tls/certs/host-cert.pem $subimageId ui
  sleep $globalSleepSecondsAfterRun

  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libWs/axis2-kernel-1.6.4.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libScim/stax-api-1.0-2.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/stax-api-1.0-2.jar
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/lib/grouper-messaging-activemq-$grouperVersion.jar"
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/grouper-messaging-activemq-$grouperVersion.jar"

  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "Listen 443 https"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf "__"
  assertFileContains /etc/httpd/conf/httpd.conf "Listen 80"
  assertFileContains /opt/tier-support/supervisord.conf "program:shibbolethsp"
  assertFileContains /opt/tier-support/supervisord.conf "program:tomee"
  assertFileContains /opt/tier-support/supervisord.conf "program:httpd"
  assertFileContains /opt/tier-support/supervisord.conf "user=shibd"
  assertFileNotContains /opt/tier-support/supervisord.conf "__"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf cachain.pem
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf /etc/pki/tls/certs/localhost.crt

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties "/tmp/logpipe"
  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties "grouper-ui;"

  assertFileNotContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties grouperPasswordConfigOverride_UI_GrouperSystem_pass.elConfig
  assertFileNotContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties thisPassIsCopyrightedDontUse

  assertFileContains /etc/httpd/conf.d/grouper-www.conf "3600"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "__"

  assertEnvVar GROUPERSCIM_PROXY_PASS "#"
  assertEnvVar GROUPERSCIM_URL_CONTEXT "grouper-ws-scim"
  assertEnvVar GROUPERWS_PROXY_PASS "#"
  assertEnvVar GROUPERWS_URL_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_APACHE_AJP_TIMEOUT_SECONDS "3600"
  assertEnvVar GROUPER_APACHE_NONSSL_PORT "80"
  assertEnvVar GROUPER_APACHE_SSL_PORT "443"
  assertEnvVar GROUPER_CHOWN_DIRS "true"
  assertEnvVar GROUPER_CONTAINER_VERSION "$containerVersion"
  assertEnvVar GROUPER_DAEMON "false"
  assertEnvVar GROUPER_GSH_CHECK_USER "true"
  assertEnvVar GROUPER_GSH_USER "tomcat"
  assertEnvVar GROUPER_HOME "/opt/grouper/grouperWebapp/WEB-INF"
  assertEnvVar GROUPER_LOG_PREFIX "grouper-ui"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_PROXY_PASS ""
  assertEnvVar GROUPER_RUN_APACHE "true"
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVar GROUPER_RUN_SHIB_SP "true"
  assertEnvVar GROUPER_RUN_TOMEE "true"
  assertEnvVar GROUPER_SCIM "false"
  assertEnvVar GROUPER_SCIM_GROUPER_AUTH "false"
  assertEnvVar GROUPER_TOMCAT_CONTEXT "grouper"
  assertEnvVar GROUPER_UI "true"
  assertEnvVar GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES "1.1.1.1/32"
  assertEnvVar GROUPER_UI_GROUPER_AUTH "false"
  assertEnvVar GROUPER_UI_ONLY "true"
  assertEnvVar GROUPER_URL_CONTEXT "grouper"
  assertEnvVar GROUPER_USE_SSL "true"
  assertEnvVar GROUPER_WS "false"
  assertEnvVar GROUPER_WS_GROUPER_AUTH "false"

  assertNumberOfTomcatProcesses 1
  # bad cert apache wont start
  assertNumberOfApacheProcesses 0
  assertNumberOfShibProcesses 1

  assertNotListeningOnPort 443
  assertNotListeningOnPort 80
  assertListeningOnPort 8009
  assertNotListeningOnPort 9001


}
export -f testContainerUiSubimage
