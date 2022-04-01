#!/bin/bash

testContainerUiSubimageNonroot() {

  if [ "$#" -ne 0 ]; then
    echo "You must enter exactly 0 command line arguments"
    exit 1
  fi

  dockerRemoveContainer
  dockerRemoveSubimage

  subimageId="my_$containerName"
  subimageName="$subimageId:latest"
  myId="$(id -u)"

  echo "" > Dockerfile
  echo "FROM $imageName" >> Dockerfile
  echo "RUN /usr/local/bin/changeUid.sh tomcat $myId" >> Dockerfile
  echo "" >> Dockerfile

  echo
  echo '################'
  echo Running container with subimage as ui without root
  echo cat DockerFile
  cat Dockerfile
  echo "docker build -t $subimageId ."
  echo "docker run --detach --name $containerName -u $myId -e GROUPER_RUN_TOMCAT_NOT_SUPERVISOR=true --publish 8080:8080 $subimageId ui"
  echo '################'
  echo

  docker build -t "$subimageId" .

  docker run --detach --name $containerName -u $myId -e GROUPER_RUN_TOMCAT_NOT_SUPERVISOR=true --publish 8080:8080 $subimageId ui
  sleep $globalSleepSecondsAfterRun

  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libWs/axis2-kernel-1.6.4.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/axis2-kernel-1.6.4.jar
  assertFileExists /opt/grouper/grouperWebapp/WEB-INF/libScim/stax-api-1.0-2.jar
  assertFileNotExists /opt/grouper/grouperWebapp/WEB-INF/lib/stax-api-1.0-2.jar
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/lib/grouper-messaging-activemq-$grouperVersion.jar"
  assertFileExists "/opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/grouper-messaging-activemq-$grouperVersion.jar"

  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml "/tmp/logpipe"
  assertFileContains /opt/grouper/grouperWebapp/WEB-INF/classes/log4j2.xml "grouper-ui;"

  assertFileNotContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties grouperPasswordConfigOverride_UI_GrouperSystem_pass.elConfig
  assertFileNotContains /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties thisPassIsCopyrightedDontUse

  assertEnvVar GROUPERSCIM_PROXY_PASS "#"
  assertEnvVar GROUPERSCIM_URL_CONTEXT "grouper-ws-scim"
  assertEnvVar GROUPERWS_PROXY_PASS "#"
  assertEnvVar GROUPERWS_URL_CONTEXT "grouper-ws"
  assertEnvVar GROUPER_APACHE_AJP_TIMEOUT_SECONDS "3600"
  assertEnvVar GROUPER_APACHE_NONSSL_PORT "80"
  assertEnvVar GROUPER_APACHE_SSL_PORT "443"
  assertEnvVarNot GROUPER_CHOWN_DIRS "true"
  assertEnvVar GROUPER_CONTAINER_VERSION "$containerVersion"
  assertEnvVar GROUPER_DAEMON "false"
  assertEnvVar GROUPER_GSH_CHECK_USER "true"
  assertEnvVar GROUPER_GSH_USER "tomcat"
  assertEnvVar GROUPER_HOME "/opt/grouper/grouperWebapp/WEB-INF"
  assertEnvVar GROUPER_LOG_PREFIX "grouper-ui"
  assertEnvVar GROUPER_MAX_MEMORY "1500m"
  assertEnvVar GROUPER_PROXY_PASS ""
  assertEnvVarNot GROUPER_RUN_APACHE "true"
  assertEnvVar GROUPER_RUN_PROCESSES_AS_USERS "true"
  assertEnvVarNot GROUPER_RUN_SHIB_SP "true"
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

  #tomcat doesnt like no database there
  #assertNumberOfTomcatProcesses 13
  # bad cert apache wont start
  assertNumberOfApacheProcesses 0
  assertNumberOfShibProcesses 0

  assertNotListeningOnPort 443
  assertNotListeningOnPort 80
  assertListeningOnPort 8009
  assertNotListeningOnPort 9001

}
export -f testContainerUiSubimageNonroot
