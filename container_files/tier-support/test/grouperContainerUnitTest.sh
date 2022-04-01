#!/bin/bash

if [ "$#" -ne 4 ]; then
  echo "You must enter exactly 4 command line arguments: container-name, image-name, container version, and grouper version, e.g. grouper-test my-grouper-2.5.27:latest 2.5.27 2.5.27"
  exit 1
fi

expectedSuccesses=716

export containerName=$1
export imageName=$2
export containerVersion=$3
export grouperVersion=$4
export globalSleepSecondsAfterRun=10
export globalExitOnError=false

export successCount=0
export failureCount=0

. ./grouperContainerUnitTestLibrary.sh

. ./grouperContainerUnitTestDaemon.sh
. ./grouperContainerUnitTestUi.sh
. ./grouperContainerUnitTestUi2.sh
. ./grouperContainerUnitTestUiNoSsl.sh
. ./grouperContainerUnitTestUiNoSslOrClient.sh
. ./grouperContainerUnitTestUiDifferentPorts.sh
. ./grouperContainerUnitTestSlashRoot.sh
. ./grouperContainerUnitTestSelfSigned.sh
. ./grouperContainerUnitTestScim.sh
. ./grouperContainerUnitTestWs.sh
. ./grouperContainerUnitTestWsAuthn.sh
. ./grouperContainerUnitTestQuickstart.sh
. ./grouperContainerUnitTestUiSubimage.sh
. ./grouperContainerUnitTestUiSubimageNonroot.sh

testContainerUi
testContainerUi2
testContainerUiNoSsl
testContainerUiNoSslOrClient
testContainerSlashRoot
testContainerSelfSigned
testContainerUiDifferentPorts
testContainerScim
testContainerWs
testContainerWsAuthn
testContainerQuickstart
testContainerDaemon
testContainerUiSubimage
testContainerUiSubimageNonroot

dockerRemoveContainer
dockerRemoveSubimage



echo ""
echo "$successCount successes, $failureCount failures"
if [ "$successCount" = "$expectedSuccesses" ] && [ "$failureCount" = "0" ]  ; then
  success=true
  echo "SUCCESS!"
else
  success=false
  echo "ERROR, expected $expectedSuccesses successes and 0 failures"
fi
echo ""
unset -f containerName
unset -f imageName
unset -f containerVersion
unset -f globalSleepSecondsAfterRun
unset -f testContainerQuickstart
unset -f testContainerDaemon
unset -f testContainerUi
unset -f testContainerUiSubimage
unset -f testContainerUiSubimageNonroot
unset -f testContainerUiNoSsl
unset -f testContainerUiDifferentPorts
unset -f testContainerSlashRoot
unset -f testContainerSelfSigned
unset -f testContainerScim
unset -f testContainerWs
unset -f successCount
unset -f failureCount
grouperContainerUnitTestLibrary_unsetAll

if [ "$success" = "true" ]; then
  exit 0
else
  exit 1
fi
