#!/bin/bash

echo "grouperContainer; INFO: (library.sh) Start loading library.sh"
#dos2unix /usr/local/bin/library*.sh
#echo "grouperContainer; INFO: (library.sh) dos2unix /usr/local/bin/library*.sh , result=$?"
#dos2unix /usr/local/bin/grouper*.sh
#echo "grouperContainer; INFO: (library.sh) dos2unix /usr/local/bin/grouper*.sh , result=$?"
#for f in /usr/local/bin/library*.sh /usr/local/bin/grouper*.sh; do
#  TFILE=$(mktemp) && dos2unix -q -n $f $TFILE && cat $TFILE > $f
#  echo "grouperContainer; INFO: (library.sh) dos2unix $f, result=$?"
#  rm $TFILE
#done

. /usr/local/bin/libraryPrep.sh
. /usr/local/bin/libraryPrepOnly.sh
. /usr/local/bin/libraryRunCommand.sh
. /usr/local/bin/librarySetupFiles.sh
. /usr/local/bin/librarySetupFilesApache.sh
. /usr/local/bin/librarySetupFilesForComponent.sh
. /usr/local/bin/librarySetupFilesForProcess.sh
. /usr/local/bin/librarySetupFilesTomcat.sh
. /usr/local/bin/librarySetupPipe.sh

# base definitions of hooks
. /usr/local/bin/grouperScriptHooksBase.sh

# need this before the copy happens
if [ -f /opt/grouper/slashRoot/usr/local/bin/grouperScriptHooks.sh ] ; then
  cp /opt/grouper/slashRoot/usr/local/bin/grouperScriptHooks.sh /usr/local/bin/grouperScriptHooks.sh
  returnCode=$?
  echo "grouperContainer; INFO: (library.sh) cp /opt/grouper/slashRoot/usr/local/bin/grouperScriptHooks.sh /usr/local/bin/grouperScriptHooks.sh, result=$returnCode"
  if [ $returnCode != 0 ]; then exit $returnCode; fi
fi
# implementations of custom hooks
. /usr/local/bin/grouperScriptHooks.sh

echo "grouperContainer; INFO: (library.sh) End loading library.sh"

