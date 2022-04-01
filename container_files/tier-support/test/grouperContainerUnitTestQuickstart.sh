#!/bin/bash

testContainerQuickstart() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer

  echo
  echo '################'
  echo Running container as quickstart
  echo "docker run --detach --name $containerName --publish 443:443 -e GROUPER_MORPHSTRING_ENCRYPT_KEY=abcdefg12345dontUseThis \ "
  echo "-e GROUPERSYSTEM_QUICKSTART_PASS=thisPassIsCopyrightedDontUse $imageName quickstart"
  echo '################'
  echo

  docker run --detach --name $containerName --publish 443:443 -e GROUPER_MORPHSTRING_ENCRYPT_KEY=abcdefg12345dontUseThis -e GROUPERSYSTEM_QUICKSTART_PASS=thisPassIsCopyrightedDontUse $imageName quickstart
  sleep $globalSleepSecondsAfterRun

  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libWs/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/lib/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libScim/stax-api-1.0-2.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/lib/stax-api-1.0-2.jar
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/lib/grouper-messaging-activemq-$grouperVersion.jar"
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/grouper-messaging-activemq-$grouperVersion.jar"

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

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties grouperPasswordConfigOverride_UI_GrouperSystem_pass.elConfig

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties GROUPERSYSTEM_QUICKSTART_PASS

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml "grouper;"

  assertFileContains /etc/httpd/conf.d/grouper-www.conf "3600"
  assertFileNotContains /etc/httpd/conf.d/grouper-www.conf "__"

  assertEnvVar GROUPERSCIM_PROXY_PASS ""
  assertEnvVar GROUPERSCIM_URL_CONTEXT "grouper-ws-scim"
  assertEnvVar GROUPERWS_PROXY_PASS ""
  assertEnvVar GROUPERWS_URL_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_APACHE_AJP_TIMEOUT_SECONDS "3600"
  assertEnvVar GROUPER_APACHE_NONSSL_PORT "80"
  assertEnvVar GROUPER_APACHE_SSL_PORT "443"
  assertEnvVar GROUPER_CHOWN_DIRS "true"
  assertEnvVar GROUPER_CONTAINER_VERSION "$containerVersion"
  assertEnvVar GROUPER_DAEMON "true"
  assertEnvVar GROUPER_GSH_CHECK_USER "true"
  assertEnvVar GROUPER_GSH_USER "tomcat"
  assertEnvVar GROUPER_HOME "/opt/grouper/grouperWebapp/WEB-INF"
  assertEnvVar GROUPER_LOG_PREFIX "grouper"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_PROXY_PASS ""
  assertEnvVar GROUPER_RUN_APACHE "true"
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVar GROUPER_RUN_SHIB_SP "false"
  assertEnvVar GROUPER_RUN_TOMEE "true"
  assertEnvVar GROUPER_SCIM "true"
  assertEnvVar GROUPER_SCIM_GROUPER_AUTH "true"
  assertEnvVar GROUPER_TOMCAT_CONTEXT "grouper"
  assertEnvVar GROUPER_UI "true"
  assertEnvVar GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES "0.0.0.0/0"
  assertEnvVar GROUPER_UI_GROUPER_AUTH "true"
  assertEnvVarNot GROUPER_UI_ONLY "true"
  assertEnvVar GROUPER_URL_CONTEXT "grouper"
  assertEnvVar GROUPER_USE_SSL "true"
  assertEnvVar GROUPER_WS "true"
  assertEnvVar GROUPER_WS_GROUPER_AUTH "true"

  assertNumberOfTomcatProcesses 1
  # bad cert apache wont start
  assertNumberOfApacheProcesses 5
  assertNumberOfShibProcesses 0

  assertListeningOnPort 443
  assertListeningOnPort 80
  assertListeningOnPort 8009
  assertListeningOnPort 9001

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost -o index.html
  assertLocalFileContains index.html document.location.href

  curl -L -k https://localhost/grouper/grouperUi/app/UiV2Main.index?operation=UiV2Main.indexMain -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:XthisPassIsCopyrightedDontUse https://localhost/grouper/grouperUi/app/UiV2Main.index?operation=UiV2Main.indexMain -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost/grouper/grouperUi/app/UiV2Main.index?operation=UiV2Main.indexMain -o index.html
  assertLocalFileContains index.html 'end index.jsp'

  curl -L -k https://localhost/grouper-ws/servicesRest/v2_4_000/subjects/GrouperSystem -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:XthisPassIsCopyrightedDontUse https://localhost/grouper-ws/servicesRest/v2_4_000/subjects/GrouperSystem -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost/grouper-ws/servicesRest/v2_4_000/subjects/GrouperSystem -o index.html
  assertLocalFileContains index.html '"resultCode":"SUCCESS"'

  curl -L -k https://localhost/grouper-ws-scim/v2/Groups/ -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:XthisPassIsCopyrightedDontUse https://localhost/grouper-ws-scim/v2/Groups/ -o index.html
  assertLocalFileContains index.html 'HTTP Status 401'

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost/grouper-ws-scim/v2/Groups/ -o index.html
  assertLocalFileContains index.html 'etc:workflowEditors'

  docker stop $containerName
  docker start $containerName

  sleep $globalSleepSecondsAfterRun

  assertNumberOfTomcatProcesses 1
  assertNumberOfApacheProcesses 5
  assertNumberOfShibProcesses 0

  assertListeningOnPort 443
  assertListeningOnPort 80
  assertListeningOnPort 8009
  assertListeningOnPort 9001

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost -o index.html
  assertLocalFileContains index.html document.location.href

  curl -L -k -u GrouperSystem:thisPassIsCopyrightedDontUse https://localhost/grouper/grouperUi/app/UiV2Main.index?operation=UiV2Main.indexMain -o index.html
  assertLocalFileContains index.html 'end index.jsp'

  containerCommandResultEquals "ps -ef | grep root | grep cat | grep -v grep | wc -l" 6
  containerCommandResultEquals "ps -ef | grep root | grep awk | grep supervisord | wc -l" 1
  containerCommandResultEquals "ps -ef | grep root | grep awk | grep grouper | wc -l" 1
  containerCommandResultEquals "ps -ef | grep root | grep awk | grep httpd | wc -l" 1
  containerCommandResultEquals "ps -ef | grep root | grep awk | grep tomee | wc -l" 1

}
export -f testContainerQuickstart
