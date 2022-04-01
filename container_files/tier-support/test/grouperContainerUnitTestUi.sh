#!/bin/bash

testContainerUi() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as ui
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_SSL_CERT_FILE=/etc/pki/tls/certs/host-cert.pem $imageName ui"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_SSL_CERT_FILE=/etc/pki/tls/certs/host-cert.pem $imageName ui
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

  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "SSLUseStapling on"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf "SSLCertificateChainFile /etc/pki/tls/certs/cachain.pem"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "SSLCertificateFile /etc/pki/tls/certs/host-cert.pem"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "SSLCertificateKeyFile /etc/pki/tls/private/host-key.pem"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "Listen 443 https"
  assertFileContains /etc/httpd/conf.d/ssl-enabled.conf "RewriteRule"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf "#RewriteRule"
  assertFileContains /etc/httpd/conf.d/grouper-www.conf "RewriteRule"
  assertFileContains /etc/httpd/conf.d/grouper-www.conf "ProxyPass /status_grouper/status ajp://localhost:8009/grouper/status timeout=2401"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "#RewriteRule"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf "__"
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf cachain.pem
  assertFileNotContains /etc/httpd/conf.d/ssl-enabled.conf /etc/pki/tls/certs/localhost.crt
  assertEnvVar GROUPER_SSL_USE_CHAIN_FILE "false"
  assertEnvVar GROUPER_SSL_CERT_FILE "/etc/pki/tls/certs/host-cert.pem"
  assertEnvVar GROUPER_SSL_KEY_FILE "/etc/pki/tls/private/host-key.pem"
  assertEnvVarNot GROUPER_SSL_CHAIN_FILE "/etc/pki/tls/certs/cachain.pem"
  assertEnvVar GROUPER_SSL_USE_STAPLING "true"

  assertFileContains /opt/tomee/conf/Catalina/localhost/grouper.xml 'cookies="true"'

  assertFileNotContains /etc/httpd/conf/httpd.conf "Options Indexes"

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties "/tmp/logpipe"
  assertFileContains /opt/tomee/conf/web.xml "<session-timeout>600</session-timeout>"
  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j.properties "grouper-ui;"

  assertFileNotContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties grouperPasswordConfigOverride_UI_GrouperSystem_pass.elConfig
  assertFileNotContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties thisPassIsCopyrightedDontUse

  assertFileContains /etc/httpd/conf.d/grouper-www.conf "3600"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "__"
  
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "ServerName"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "UseCanonicalName On"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "RemoteIPHeader"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "RemoteIPTrustedProxy"

  assertFileNotContains /opt/tomee/conf/server.xml "AccessLogValve"

  assertFileContains /opt/tomee/conf/server.xml "maxHeaderCount"
  assertFileContains /opt/tomee/conf/server.xml "200"
  assertFileNotContains /opt/tomee/conf/server.xml "1235"

  assertFileContains /opt/tomee/conf/server.xml "tomcatAuthentication"

  assertEnvVarNot GROUPER_APACHE_SERVER_NAME https://a.b.c:443
  assertEnvVar GROUPER_TOMCAT_LOG_ACCESS "false"
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
  assertEnvVar GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES "127.0.0.1/32"
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
  assertListeningOnPort 8080
  #assertListeningOnPort 8005


}
export -f testContainerUi
