#!/bin/bash

testContainerWsAuthn() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ws with tomcat authn
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_APACHE_SERVER_NAME=https://a.b.c:443 -e GROUPER_WS_TOMCAT_AUTHN=true $imageName ws"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_SELF_SIGNED_CERT=true -e GROUPER_APACHE_SERVER_NAME=https://a.b.c:443 -e GROUPER_WS_TOMCAT_AUTHN=true $imageName ws
  sleep $globalSleepSecondsAfterRun

  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libWs/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/lib/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libScim/stax-api-1.0-2.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/stax-api-1.0-2.jar
  assertFileNotExists "/opt/grouper/grouperWebapp/WEB-INF/lib/grouper-messaging-activemq-$grouperVersion.jar"
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/grouper-messaging-activemq-$grouperVersion.jar"

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/web.xml "<auth-method>BASIC</auth-method>"
  assertFileContains /opt/tomee/conf/server.xml 'tomcatAuthentication="true"'
  assertFileNotContains /opt/tomee/conf/server.xml 'tomcatAuthentication="false"'

  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "Listen 443 https"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf "__"
  assertFileContains /etc/httpd/conf/httpd.conf "Listen 80"
  assertFileNotContains /opt/tier-support/supervisord.conf "program:shibbolethsp"
  assertFileContains /opt/tier-support/supervisord.conf "program:tomee"
  assertFileContains /opt/tier-support/supervisord.conf "program:httpd"
  assertFileNotContains /opt/tier-support/supervisord.conf "user=shibd"
  assertFileNotContains /opt/tier-support/supervisord.conf "__"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf cachain.pem
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf /etc/pki/tls/certs/localhost.crt

  assertFileContains /opt/tomee/conf/Catalina/localhost/grouper-ws.xml 'cookies="false"'
  assertFileContains /opt/tomee/conf/web.xml "<session-timeout>1</session-timeout>"

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml "grouper-ws;"

  assertFileContains /etc/httpd/conf.d/grouper-www.conf "3600"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "__"

  assertFileContains /etc/httpd/conf.d/grouper-www.conf "ServerName https://a.b.c:443"
  assertFileContains /etc/httpd/conf.d/grouper-www.conf "UseCanonicalName On"

  assertEnvVar GROUPER_APACHE_SERVER_NAME https://a.b.c:443
  assertEnvVar GROUPERSCIM_PROXY_PASS "#"
  assertEnvVar GROUPERSCIM_URL_CONTEXT "grouper-ws-scim"
  assertEnvVar GROUPERWS_PROXY_PASS ""
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
  assertEnvVar GROUPER_LOG_PREFIX "grouper-ws"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_PROXY_PASS "#"
  assertEnvVar GROUPER_RUN_APACHE "true"
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVarNot GROUPER_RUN_SHIB_SP "true"
  assertEnvVar GROUPER_RUN_TOMEE "true"
  assertEnvVar GROUPER_SCIM "false"
  assertEnvVar GROUPER_SCIM_GROUPER_AUTH "false"
  assertEnvVar GROUPER_TOMCAT_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_UI "false"
  assertEnvVar GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES "127.0.0.1/32"
  assertEnvVar GROUPER_UI_GROUPER_AUTH "false"
  assertEnvVarNot GROUPER_UI_ONLY "true"
  assertEnvVar GROUPER_URL_CONTEXT "grouper"
  assertEnvVar GROUPER_USE_SSL "true"
  assertEnvVar GROUPER_WS "true"
  assertEnvVar GROUPER_WS_GROUPER_AUTH "false"
  assertEnvVar GROUPER_WS_ONLY "true"

  assertNumberOfTomcatProcesses 1
  assertNumberOfApacheProcesses 5
  assertNumberOfShibProcesses 0

  assertListeningOnPort 443
  assertListeningOnPort 80
  assertListeningOnPort 8009
  assertNotListeningOnPort 9001

}
export -f testContainerWsAuthn
