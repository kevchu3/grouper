#!/bin/bash

setupFilesForComponent_ws() {

  # copy files to their appropriate locations based on passed in flags
  if [ "$GROUPER_WS" = "true" ]
     then
       cp -r /opt/grouper/grouperWebapp/WEB-INF/libWs/* /opt/grouper/grouperWebapp/WEB-INF/lib/
       returnCode=$?
       echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ws) cp -r /opt/grouper/grouperWebapp/WEB-INF/libWs/* /opt/grouper/grouperWebapp/WEB-INF/lib/ , result: $returnCode"
       if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesForComponent_scim() {

  if [ "$GROUPER_SCIM" = "true" ]
     then
       cp -r /opt/grouper/grouperWebapp/WEB-INF/libScim/* /opt/grouper/grouperWebapp/WEB-INF/lib/
       returnCode=$?
       echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_scim) cp -r /opt/grouper/grouperWebapp/WEB-INF/libScim/* /opt/grouper/grouperWebapp/WEB-INF/lib/ , result: $returnCode"
       if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesForComponent_ui() {

  if [ "$GROUPER_UI" = "true" ] || [ "$GROUPER_DAEMON" = "true" ]
     then
       cp -r /opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/* /opt/grouper/grouperWebapp/WEB-INF/lib/
       returnCode=$?
       echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_ui) cp -r /opt/grouper/grouperWebapp/WEB-INF/libUiAndDaemon/* /opt/grouper/grouperWebapp/WEB-INF/lib/ , result: $returnCode"
       if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesForComponent_quickstart() {

    if [ ! -z "$GROUPERSYSTEM_QUICKSTART_PASS" ]
      then
        if [ "$GROUPER_UI_GROUPER_AUTH" = 'true' ]
          then
            echo '' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.base.properties
            echo 'grouperPasswordConfigOverride_UI_GrouperSystem_pass.elConfig = ${elUtils.processEnvVarOrFile('"'"'GROUPERSYSTEM_QUICKSTART_PASS'"'"')}' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties
            returnCode=$?
            echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_quickstart) edit grouper.hibernate.base.properties with UI GrouperSystem password for quick start, result: $returnCode"
            if [ $returnCode != 0 ]; then exit $returnCode; fi
        fi
        if [ "$GROUPER_WS_GROUPER_AUTH" = 'true' ]
          then         
            echo '' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.base.properties
            echo 'grouperPasswordConfigOverride_WS_GrouperSystem_pass.elConfig = ${elUtils.processEnvVarOrFile('"'"'GROUPERSYSTEM_QUICKSTART_PASS'"'"')}' >> /opt/grouper/grouperWebapp/WEB-INF/classes/grouper.hibernate.properties
            returnCode=$?
            echo "grouperContainer; INFO: (librarySetupFilesForComponent.sh-setupFilesForComponent_quickstart) edit grouper.hibernate.base.properties with WS GrouperSystem password for quick start, result: $returnCode"
            if [ $returnCode != 0 ]; then exit $returnCode; fi
        fi
    fi

}

setupFilesForComponent() {
  
  setupFilesForComponent_ws

  setupFilesForComponent_scim
  
  setupFilesForComponent_ui

  setupFilesForComponent_quickstart

}


setupFilesForComponent_unsetAll() {
  unset -f setupFilesForComponent
  unset -f setupFilesForComponent_quickstart
  unset -f setupFilesForComponent_scim
  unset -f setupFilesForComponent_ui
  unset -f setupFilesForComponent_unsetAll
  unset -f setupFilesForComponent_ws
}

setupFilesForComponent_exportAll() {
  export -f setupFilesForComponent
  export -f setupFilesForComponent_quickstart
  export -f setupFilesForComponent_scim
  export -f setupFilesForComponent_ui
  export -f setupFilesForComponent_unsetAll
  export -f setupFilesForComponent_ws
  
}

# export everything
setupFilesForComponent_exportAll


