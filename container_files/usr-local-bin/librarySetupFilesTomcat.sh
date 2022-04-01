#!/bin/bash

setupFilesTomcat() {
  setupFilesTomcat_turnOnAjp
  setupFilesTomcat_supervisor
  setupFilesTomcat_authn
  setupFilesTomcat_context
  setupFilesTomcat_ports
  setupFilesTomcat_accessLogs
  setupFilesTomcat_sessionTimeout
  setupFilesTomcat_ssl
}


setupFilesTomcat_turnOnAjp() {

  if [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]; then
    cp /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.currentOriginalInContainer
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) cp /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.currentOriginalInContainer , result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi

    patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.turnOnAjp.patch
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) Patch server.xml to turn on ajp: patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.turnOnAjp.patch, result: $returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
  else
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_turnOnAjp) /opt/tomee/conf/server.xml is not the original file so will not be edited"
  fi
  
}

setupFilesTomcat_accessLogs() {
  
  if [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]; then
    if [ "$GROUPER_TOMCAT_LOG_ACCESS" = "true" ]; then
    
      # this patch happens after the last patch
      patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.loggingpipe.patch
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) Patch server.xml to log access: patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.loggingpipe.patch , result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
    else  
  
      patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.nologging.patch
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) Patch server.xml to not log access: patch /opt/tomee/conf/server.xml /opt/tomee/conf/server.xml.nologging.patch , result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
    fi
  else
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_accessLogs) /opt/tomee/conf/server.xml is not the original file so will not be edited"
  fi
  
}

setupFilesTomcat_ports() {

      if [ "$GROUPER_TOMCAT_HTTP_PORT" != "8080" ]; then 
        sed -i "s|8080|$GROUPER_TOMCAT_HTTP_PORT|g" /opt/tomee/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change http port: sed -i \"s|8080|$GROUPER_TOMCAT_HTTP_PORT|g\" /opt/tomee/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
      if [ "$GROUPER_TOMCAT_AJP_PORT" != "8009" ]; then 
        sed -i "s|8009|$GROUPER_TOMCAT_AJP_PORT|g" /opt/tomee/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change ajp port: sed -i \"s|8009|$GROUPER_TOMCAT_AJP_PORT|g\" /opt/tomee/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
      
      if [ "$GROUPER_TOMCAT_MAX_HEADER_COUNT" != "-1" ]; then 
        # add in maxHeaderCount since new chrome sends too many headers
        sed -i "s|port=\"$GROUPER_TOMCAT_AJP_PORT\"|port=\"$GROUPER_TOMCAT_AJP_PORT\" maxHeaderCount=\"$GROUPER_TOMCAT_MAX_HEADER_COUNT\" |g" /opt/tomee/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml add maxHeaderCount: sed -i \"s|port=\"$GROUPER_TOMCAT_AJP_PORT\"|port=\"$GROUPER_TOMCAT_AJP_PORT\" maxHeaderCount=\"$GROUPER_TOMCAT_MAX_HEADER_COUNT\" |g\" /opt/tomee/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
  
      if [ "$GROUPER_TOMCAT_SHUTDOWN_PORT" != "8005" ]; then 
        sed -i "s|8005|$GROUPER_TOMCAT_SHUTDOWN_PORT|g" /opt/tomee/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ports) update server.xml to change shutdown port: sed -i \"s|8005|$GROUPER_TOMCAT_SHUTDOWN_PORT|g\" /opt/tomee/conf/server.xml , result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      fi
}

setupFilesTomcat_context() {

  if [ -f /opt/tomee/conf/Catalina/localhost/grouper.xml ]
    then
      if [ "$GROUPER_ORIGFILE_GROUPER_XML" = "true" ]; then
        # ws only and scim only dont have cookies
        sed -i "s|__GROUPER_CONTEXT_COOKIES__|$GROUPER_CONTEXT_COOKIES|g" /opt/tomee/conf/Catalina/localhost/grouper.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) Replace context cookies in grouper.xml: sed -i \"s|__GROUPER_CONTEXT_COOKIES__|$GROUPER_CONTEXT_COOKIES|g\" /opt/tomee/conf/Catalina/localhost/grouper.xml , result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
        
        # setup context
        sed -i "s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g" /opt/tomee/conf/Catalina/localhost/grouper.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) Replace tomcat context in grouper.xml: sed -i \"s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g\" /opt/tomee/conf/Catalina/localhost/grouper.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
        
        # rename file if needed since that can matter with tomcat
        if [ "$GROUPER_TOMCAT_CONTEXT" != "grouper" ]
          then  
            mv -v /opt/tomee/conf/Catalina/localhost/grouper.xml "/opt/tomee/conf/Catalina/localhost/$GROUPER_TOMCAT_CONTEXT.xml"
            returnCode=$?
            echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) mv -v /opt/tomee/conf/Catalina/localhost/grouper.xml \"/opt/tomee/conf/Catalina/localhost/$GROUPER_TOMCAT_CONTEXT.xml\" , result: $returnCode"
            if [ $returnCode != 0 ]; then exit $returnCode; fi
        fi
      else
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) /opt/tomee/conf/Catalina/localhost/grouper.xml is not the original file so will not be edited"
      fi    
  fi

  # setup the apache linkage to tomcat  
  if [ -f /etc/httpd/conf.d/grouper-www.conf ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]
    then
      sed -i "s|__GROUPER_APACHE_AJP_TIMEOUT_SECONDS__|$GROUPER_APACHE_AJP_TIMEOUT_SECONDS|g" /etc/httpd/conf.d/grouper-www.conf
      results="$?"
      sed -i "s|__GROUPER_TOMCAT_CONTEXT__|$GROUPER_TOMCAT_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPER_URL_CONTEXT__|$GROUPER_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPERWS_URL_CONTEXT__|$GROUPERWS_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPERSCIM_URL_CONTEXT__|$GROUPERSCIM_URL_CONTEXT|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPER_PROXY_PASS__|$GROUPER_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"

      if [ "$GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER" = "true" ]; then
        sed -i "s|__GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER__||g" /etc/httpd/conf.d/grouper-www.conf
        results="$results $?"
      else
        sed -i "s|__GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER__|#|g" /etc/httpd/conf.d/grouper-www.conf
        results="$results $?"
      fi

      if [ -f /etc/httpd/conf.d/ssl-enabled.conf ]; then
        sed -i "s|__GROUPER_PROXY_PASS__|$GROUPER_PROXY_PASS|g" /etc/httpd/conf.d/ssl-enabled.conf
        results="$results $?"

        if [ "$GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER" = "true" ]; then
          sed -i "s|__GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER__||g" /etc/httpd/conf.d/ssl-enabled.conf
          results="$results $?"
        else
          sed -i "s|__GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER__|#|g" /etc/httpd/conf.d/ssl-enabled.conf
          results="$results $?"
        fi
      fi
      sed -i "s|__GROUPERSCIM_PROXY_PASS__|$GROUPERSCIM_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      results="$results $?"
      sed -i "s|__GROUPERWS_PROXY_PASS__|$GROUPERWS_PROXY_PASS|g" /etc/httpd/conf.d/grouper-www.conf
      returnCode=$?
      results="$results $returnCode"
      if [ "$GROUPER_TOMCAT_AJP_PORT" != "8009" ]; then 
        sed -i "s|:8009/|:$GROUPER_TOMCAT_AJP_PORT/|g" /etc/httpd/conf.d/grouper-www.conf
        results="$results $?"
      fi
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_context) Set contexts in grouper-www.conf and other files, results: $results"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesTomcat_authn() {

    if [ "$GROUPER_WS_TOMCAT_AUTHN" = "true" ] 
      then
      
        if [ "$GROUPER_ORIGFILE_WEBAPP_WEB_XML" = "true" ]; then
          cp /opt/tier-support/web.wsTomcatAuthn.xml /opt/grouper/grouperWebapp/WEB-INF/web.xml
          returnCode=$?
          echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) cp /opt/tier-support/web.wsTomcatAuthn.xml /opt/grouper/grouperWebapp/WEB-INF/web.xml , result: $returnCode"
          if [ $returnCode != 0 ]; then exit $returnCode; fi
        else
          echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) /opt/grouper/grouperWebapp/WEB-INF/web.xml is not the original file so will not be edited"
        fi

        sed -i 's|tomcatAuthentication="false"|tomcatAuthentication="true"|g' /opt/tomee/conf/server.xml
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_authn) sed -i 's|tomcatAuthentication=\"false\"|tomcatAuthentication=\"true\"|g' /opt/tomee/conf/server.xml, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi

    fi

}

setupFilesTomcat_supervisor() {

  if [ "$GROUPER_RUN_TOMEE" = "true" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]
    then
      cat /opt/tier-support/supervisord-tomee.conf >> /opt/tier-support/supervisord.conf
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_supervisor) Append supervisord-tomee.conf to supervisord.conf: cat /opt/tier-support/supervisord-tomee.conf >> /opt/tier-support/supervisord.conf , result: $returnCode"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesTomcat_sessionTimeout() {

  if [ "$GROUPER_RUN_TOMEE" = "true" ] && [ "$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES" != "-2" ]
    then
    sed -i "s|<session-timeout>30</session-timeout>|<session-timeout>$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES</session-timeout>|g" /opt/tomee/conf/web.xml
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_sessionTimeout) based on GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES, sed -i \"s|<session-timeout>30</session-timeout>|<session-timeout>$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES</session-timeout>|g\" /opt/tomee/conf/web.xml , result=$returnCode"
    if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi
}

setupFilesTomcat_ssl() {

  if [ "$GROUPER_WEBCLIENT_IS_SSL" = "false" ]
    then
    sed -i 's|secure="true"||g' /opt/tomee/conf/server.xml
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ssl) based on GROUPER_WEBCLIENT_IS_SSL, sed -i 's|secure=\"true\"||g' /opt/tomee/conf/server.xml , result=$returnCode"
    if [ $returnCode != 0 ] && [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]
      then
        exit $returnCode
    fi  
    sed -i 's|scheme="https"|scheme="http"|g' /opt/tomee/conf/server.xml
    returnCode=$?
    echo "grouperContainer; INFO: (librarySetupFilesTomcat.sh-setupFilesTomcat_ssl) based on GROUPER_WEBCLIENT_IS_SSL, sed -i 's|scheme=\"https\"|scheme=\"http\"|g' /opt/tomee/conf/server.xml , result=$returnCode"
    if [ $returnCode != 0 ] && [ "$GROUPER_ORIGFILE_SERVER_XML" = "true" ]
      then
        exit $returnCode
    fi  
  fi
}


setupFilesTomcat_unsetAll() {

  unset -f setupFilesTomcat
  unset -f setupFilesTomcat_authn
  unset -f setupFilesTomcat_context
  unset -f setupFilesTomcat_ports
  unset -f setupFilesTomcat_ssl
  unset -f setupFilesTomcat_supervisor
  unset -f setupFilesTomcat_unsetAll
  unset -f setupFilesTomcat_accessLogs
  unset -f setupFilesTomcat_sessionTimeout
  unset -f setupFilesTomcat_turnOnAjp

}

setupFilesTomcat_exportAll() {

  export -f setupFilesTomcat
  export -f setupFilesTomcat_authn
  export -f setupFilesTomcat_context
  export -f setupFilesTomcat_ports
  export -f setupFilesTomcat_ssl
  export -f setupFilesTomcat_supervisor
  export -f setupFilesTomcat_unsetAll
  export -f setupFilesTomcat_accessLogs
  export -f setupFilesTomcat_sessionTimeout
  export -f setupFilesTomcat_turnOnAjp
}

# export everything
setupFilesTomcat_exportAll

