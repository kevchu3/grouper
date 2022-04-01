#!/bin/bash

. /usr/local/bin/library.sh
prep_conf

if [ "$#" -eq 0 ];
  then
    echo "grouperContainer; INFO: (entrypoint.sh) No component set to run"
    prep_finish
    setupFiles
    runCommand
else

#  echo "$@"

#  argc=$#
#  argv=("$@")

  GROUPER_ENTRYPOINT_COMMAND=$1
  shift
  
#  for (( j=1; j<argc; j++ )); do
#    if [ -n "$ARGUMENTS" ]; then
#      ARGUMENTS="$ARGUMENTS "
#    fi
#    ARGUMENTS="$ARGUMENTS${argv[j]}"
#  done

  if [ "$GROUPER_ENTRYPOINT_COMMAND" = "/opt/grouper/grouperWebapp/WEB-INF/bin/gsh.sh" ]
    then
      GROUPER_ENTRYPOINT_COMMAND=gsh
  fi

  echo "grouperContainer; INFO: (entrypoint.sh) Executing $GROUPER_ENTRYPOINT_COMMAND $@"
  exec "$GROUPER_ENTRYPOINT_COMMAND" "$@"                                                                                                          
fi

