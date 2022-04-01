#!/bin/bash

prep_openshift() {
  if [ "$GROUPER_OPENSHIFT" == 'true' ]; then
    echo "grouperContainer; INFO: (libraryPrep.sh-prep_openshift) GROUPER_OPENSHIFT is true"
    if [ -z "$GROUPER_CHOWN_DIRS" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_openshift) export GROUPER_CHOWN_DIRS=false"
      export GROUPER_CHOWN_DIRS=false
    fi
    if [ -z "$GROUPER_SHIB_LOG_USE_PIPE" ]; then
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_openshift) export GROUPER_SHIB_LOG_USE_PIPE=false"    
      export GROUPER_SHIB_LOG_USE_PIPE=false
    fi
    if [ -z "$GROUPER_USE_PIPES" ]; then
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_openshift) export GROUPER_USE_PIPES=false"    
      export GROUPER_USE_PIPES=false
    fi
    if [ -z "$GROUPER_GSH_CHECK_USER" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_openshift) export GROUPER_GSH_CHECK_USER=false"    
      export GROUPER_GSH_CHECK_USER=false
    fi
    if [ -z "$GROUPER_RUN_PROCESSES_AS_USERS" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_openshift) export GROUPER_RUN_PROCESSES_AS_USERS=false"    
      export GROUPER_RUN_PROCESSES_AS_USERS=false
    fi
  fi
}

prep_quickstart() {
    
    if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ]; then
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) GROUPER_RUN_TOMCAT_NOT_SUPERVISOR is not true"    
      if [ -z "$GROUPER_SELF_SIGNED_CERT" ] && [ "$GROUPER_OPENSHIFT" != "true" ]; then 
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_SELF_SIGNED_CERT=true"    
        export GROUPER_SELF_SIGNED_CERT=true
      fi
      if [ -z "$GROUPER_START_DELAY_SECONDS" ]; then 
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_START_DELAY_SECONDS='10'"    
        export GROUPER_START_DELAY_SECONDS='10'
      fi
    fi
    if [ -z "$GROUPER_RUN_SHIB_SP" ] && [ "$GROUPER_OPENSHIFT" != "true" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_RUN_SHIB_SP=false"    
      export GROUPER_RUN_SHIB_SP=false
    fi
    if [ -z "$GROUPER_AUTO_DDL_UPTOVERSION" ]; then
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_AUTO_DDL_UPTOVERSION='v2.6.*'"    
      export GROUPER_AUTO_DDL_UPTOVERSION='v2.6.*'
    fi
    if [ -z "$GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='0.0.0.0/0'"    
      export GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='0.0.0.0/0'
    fi
    # wait for database to start
    if [ -z "$GROUPER_UI_GROUPER_AUTH" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_UI_GROUPER_AUTH='true'"    
      export GROUPER_UI_GROUPER_AUTH='true'
    fi
    if [ -z "$GROUPER_WS_GROUPER_AUTH" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_WS_GROUPER_AUTH='true'"    
      export GROUPER_WS_GROUPER_AUTH='true'
    fi
    if [ -z "$GROUPER_SCIM_GROUPER_AUTH" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_SCIM_GROUPER_AUTH=true"    
      export GROUPER_SCIM_GROUPER_AUTH=true
    fi
    if [ -z "$GROUPER_QUICKSTART" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_quickstart) export GROUPER_QUICKSTART=true"    
      export GROUPER_QUICKSTART=true
    fi

}

prep_daemon() {
    
    if [ -z "$GROUPER_DAEMON" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_daemon) export GROUPER_DAEMON=true"    
      export GROUPER_DAEMON=true
    fi
    if [ -z "$GROUPER_RUN_TOMEE" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_daemon) export GROUPER_RUN_TOMEE=true"    
      export GROUPER_RUN_TOMEE=true
    fi
}

prep_scim() {
    
    if [ -z "$GROUPER_SCIM" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_scim) export GROUPER_SCIM=true"    
      export GROUPER_SCIM=true
    fi
    if [ -z "$GROUPER_RUN_APACHE" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ] && [ "$GROUPER_OPENSHIFT" != "true" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_scim) export GROUPER_RUN_APACHE=true"    
      export GROUPER_RUN_APACHE=true
    fi
    if [ -z "$GROUPER_RUN_TOMEE" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_scim) export GROUPER_RUN_TOMEE=true"    
      export GROUPER_RUN_TOMEE=true
    fi
}

prep_ui() {

    if [ -z "$GROUPER_UI" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_ui) export GROUPER_UI=true"    
      export GROUPER_UI=true
    fi
    if [ -z "$GROUPER_RUN_APACHE" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ] && [ "$GROUPER_OPENSHIFT" != "true" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_ui) export GROUPER_RUN_APACHE=true"    
      export GROUPER_RUN_APACHE=true
    fi
    if [ -z "$GROUPER_RUN_SHIB_SP" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ] && [ "$GROUPER_OPENSHIFT" != "true" ]; then
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_ui) export GROUPER_RUN_SHIB_SP=true"    
      export GROUPER_RUN_SHIB_SP=true
    fi
    if [ -z "$GROUPER_RUN_TOMEE" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_ui) export GROUPER_RUN_TOMEE=true"    
      export GROUPER_RUN_TOMEE=true
    fi
}

prep_runUi() {
  if [ -z "$GROUPER_PROXY_PASS" ]
    then
      if [ "$GROUPER_UI" == 'true' ]
        then
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_runUi) export GROUPER_PROXY_PASS="    
          export GROUPER_PROXY_PASS=
        else
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_runUi) export GROUPER_PROXY_PASS=#"    
          export GROUPER_PROXY_PASS=#
      fi
    
  fi
}
prep_runWs() {
  if [ -z "$GROUPERWS_PROXY_PASS" ]
    then
      if [ "$GROUPER_WS" == 'true' ]
        then
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_runWs) export GROUPER_PROXY_PASS="    
          export GROUPERWS_PROXY_PASS=
        else
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_runWs) export GROUPER_PROXY_PASS=#"    
          export GROUPERWS_PROXY_PASS=#
      fi
    
  fi
}
prep_runScim() {
  if [ -z "$GROUPERSCIM_PROXY_PASS" ]
    then
      if [ "$GROUPER_SCIM" == 'true' ]
        then
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_runScim) export GROUPER_PROXY_PASS="    
          export GROUPERSCIM_PROXY_PASS=
        else
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_runScim) export GROUPER_PROXY_PASS=#"    
          export GROUPERSCIM_PROXY_PASS=#
      fi
    
  fi
}


prep_ws() {

    if [ -z "$GROUPER_WS" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_ws) export GROUPER_WS=true"    
      export GROUPER_WS=true
    fi
    if [ -z "$GROUPER_RUN_APACHE" ] && [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" != "true" ] && [ "$GROUPER_OPENSHIFT" != "true" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_ws) export GROUPER_RUN_APACHE=true"    
      export GROUPER_RUN_APACHE=true
    fi
    if [ -z "$GROUPER_RUN_TOMEE" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_ws) export GROUPER_RUN_TOMEE=true"    
      export GROUPER_RUN_TOMEE=true
    fi
}

prep_conf() {

    echo "grouperContainer; INFO: (libraryPrep.sh-prep_conf) Start setting up initial pipes"
    if [ -z "$GROUPER_USE_PIPES" ]; then
      if [ "$GROUPER_OPENSHIFT" != 'true' ]; then
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_conf) GROUPER_USE_PIPES=true"
        export GROUPER_USE_PIPES=true
      fi
    fi
    setupPipe_logging
    setupPipe_supervisordLog
    setupPipe_grouperLog
    echo "grouperContainer; INFO: (libraryPrep.sh-prep_conf) End setting up initial pipes"
    
    # if we are stopping and starting, we just read the env vars and we done
    if [ -f /opt/grouper/grouperEnv.sh ]
      then
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_conf) Loading env vars from /opt/grouper/grouperEnv.sh"
        . /opt/grouper/grouperEnv.sh
        return
    fi
    
    prep_initDeprecatedEnvVars
    grouperScriptHooks_prepConfPost

}

prep_initDeprecatedEnvVars() {

  if [ ! -z "$RUN_APACHE" ] && [ -z "$GROUPER_RUN_APACHE" ]
    then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_initDeprecatedEnvVars) export GROUPER_RUN_APACHE=$RUN_APACHE"
      export GROUPER_RUN_APACHE="$RUN_APACHE"
  fi

  if [ ! -z "$RUN_SHIB_SP" ] && [ -z "$GROUPER_RUN_SHIB_SP" ]
    then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_initDeprecatedEnvVars) export GROUPER_RUN_SHIB_SP=$RUN_SHIB_SP"
      export GROUPER_RUN_SHIB_SP="$RUN_SHIB_SP"
  fi

  if [ ! -z "$RUN_TOMEE" ] && [ -z "$GROUPER_RUN_TOMEE" ]
    then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_initDeprecatedEnvVars) export GROUPER_RUN_TOMEE=$RUN_TOMEE"
      export GROUPER_RUN_TOMEE="$RUN_TOMEE"
  fi

  if [ ! -z "$SELF_SIGNED_CERT" ] && [ -z "$GROUPER_SELF_SIGNED_CERT" ]
    then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_initDeprecatedEnvVars) export GROUPER_SELF_SIGNED_CERT=$SELF_SIGNED_CERT"
      export GROUPER_SELF_SIGNED_CERT="$SELF_SIGNED_CERT"
  fi

}


prep_finishBegin() {
    # default a lot of env variables
    # morph defaults to null
    # database password defaults to null
    prep_openshift
    if [ -z "$GROUPER_UI_GROUPER_AUTH" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_UI_GROUPER_AUTH=false"
      export GROUPER_UI_GROUPER_AUTH=false
    fi
    if [ -z "$GROUPER_WS_GROUPER_AUTH" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_WS_GROUPER_AUTH=false"
      export GROUPER_WS_GROUPER_AUTH=false
    fi
    if [ -z "$GROUPER_SCIM_GROUPER_AUTH" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SCIM_GROUPER_AUTH=false"
      export GROUPER_SCIM_GROUPER_AUTH=false
    fi
    if [ -z "$GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='127.0.0.1/32'"
      export GROUPER_UI_CONFIGURATION_EDITOR_SOURCEIPADDRESSES='127.0.0.1/32'
    fi
    # GROUPER_AUTO_DDL_UPTOVERSION defaults to null
    # GROUPER_START_DELAY_SECONDS defaults to null
    if [ -z "$GROUPER_UI" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) GROUPER_UI=false"
      export GROUPER_UI=false
    fi
    if [ -z "$GROUPER_SCIM" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SCIM=false"
      export GROUPER_SCIM=false
    fi
    if [ -z "$GROUPER_WS" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_WS=false"
      export GROUPER_WS=false
    fi
    if [ -z "$GROUPER_DAEMON" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_DAEMON=false"
      export GROUPER_DAEMON=false
    fi
    if [ -z "$GROUPER_USE_SSL" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_USE_SSL=true"
      export GROUPER_USE_SSL=true
    fi
    if [ "$GROUPER_USE_SSL" = "true" ]; then
      if [ -z "$GROUPER_SELF_SIGNED_CERT" ] && [ -z "$GROUPER_SSL_CERT_FILE" ] && [ ! -f /etc/pki/tls/certs/host-cert.pem ] ; then 
      
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) GROUPER_SELF_SIGNED_CERT and GROUPER_SSL_CERT_FILE are not specified and /etc/pki/tls/certs/host-cert.pem does not exist, so: export GROUPER_SELF_SIGNED_CERT=true"
        export GROUPER_SELF_SIGNED_CERT=true
      
      fi
      if [ "$GROUPER_SELF_SIGNED_CERT" = "true" ]; then
  
        # default the cert path to self signed and no chain file
        if [ -z "$GROUPER_SSL_CERT_FILE" ] ; then 
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_CERT_FILE=/etc/pki/tls/certs/localhost.crt"
          export GROUPER_SSL_CERT_FILE=/etc/pki/tls/certs/localhost.crt
        fi
        if [ -z "$GROUPER_SSL_KEY_FILE" ] ; then 
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_KEY_FILE=/etc/pki/tls/private/localhost.key"
          export GROUPER_SSL_KEY_FILE=/etc/pki/tls/private/localhost.key
        fi
        if [ -z "$GROUPER_SSL_CHAIN_FILE" ] && [ -z "$GROUPER_SSL_USE_CHAIN_FILE" ] ; then 
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_USE_CHAIN_FILE=false"
          export GROUPER_SSL_USE_CHAIN_FILE=false
        fi
      
      fi
      # default the cert path
      if [ -z "$GROUPER_SSL_CERT_FILE" ] ; then 
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_CERT_FILE=/etc/pki/tls/certs/host-cert.pem"
        export GROUPER_SSL_CERT_FILE=/etc/pki/tls/certs/host-cert.pem
      fi
      if [ -z "$GROUPER_SSL_KEY_FILE" ] ; then 
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_KEY_FILE=/etc/pki/tls/private/host-key.pem"
        export GROUPER_SSL_KEY_FILE=/etc/pki/tls/private/host-key.pem
      fi
      if [ -z "$GROUPER_SSL_CHAIN_FILE" ] ; then 
      
        if [ -f /etc/pki/tls/certs/cachain.pem ]; then
      
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_USE_CHAIN_FILE=true"
          export GROUPER_SSL_USE_CHAIN_FILE=true
          echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_CHAIN_FILE=/etc/pki/tls/certs/cachain.pem"
          export GROUPER_SSL_CHAIN_FILE=/etc/pki/tls/certs/cachain.pem
        else 

          echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_USE_CHAIN_FILE=false"
          export GROUPER_SSL_USE_CHAIN_FILE=false
        
        fi
      fi
      if [ -z "$GROUPER_SSL_USE_CHAIN_FILE" ] ; then 

        if [ -z "$GROUPER_SSL_CHAIN_FILE" ]; then

          echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_USE_CHAIN_FILE=false"
          export GROUPER_SSL_USE_CHAIN_FILE=false

        else

          echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_USE_CHAIN_FILE=true"
          export GROUPER_SSL_USE_CHAIN_FILE=true
        
        fi
      
      fi
      if [ -z "$GROUPER_SSL_USE_STAPLING" ] ; then 

        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SSL_USE_STAPLING=true"
        export GROUPER_SSL_USE_STAPLING=true
      
      fi
      
    fi
    if [ -z "$GROUPER_WEBCLIENT_IS_SSL" ] ; then 

      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_WEBCLIENT_IS_SSL=true (browser or WS client is SSL)"
      export GROUPER_WEBCLIENT_IS_SSL=true
    
    fi
    
    if [ -z "$GROUPER_RUN_PROCESSES_AS_USERS" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_RUN_PROCESSES_AS_USERS=true"
      export GROUPER_RUN_PROCESSES_AS_USERS=true
    fi

    # do these before the "only" component
    if [ -z "$GROUPER_URL_CONTEXT" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_URL_CONTEXT=grouper"
      export GROUPER_URL_CONTEXT=grouper
    fi
    if [ -z "$GROUPERWS_URL_CONTEXT" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPERWS_URL_CONTEXT=grouper-ws"
      export GROUPERWS_URL_CONTEXT=grouper-ws
    fi
    if [ -z "$GROUPERSCIM_URL_CONTEXT" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPERSCIM_URL_CONTEXT=grouper-ws-scim"
      export GROUPERSCIM_URL_CONTEXT=grouper-ws-scim
    fi
    if [ -z "$GROUPER_APACHE_AJP_TIMEOUT_SECONDS" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_APACHE_AJP_TIMEOUT_SECONDS=3600"
      export GROUPER_APACHE_AJP_TIMEOUT_SECONDS=3600
    fi
    if [ -z "$GROUPER_APACHE_SSL_PORT" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_APACHE_SSL_PORT=443"
      export GROUPER_APACHE_SSL_PORT=443
    fi
    if [ -z "$GROUPER_APACHE_NONSSL_PORT" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_APACHE_NONSSL_PORT=80"
      export GROUPER_APACHE_NONSSL_PORT=80
    fi
    if [ -z "$GROUPER_APACHE_DIRECTORY_INDEXES" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_APACHE_DIRECTORY_INDEXES=false"
      export GROUPER_APACHE_DIRECTORY_INDEXES=false
    fi
    
    if [ -z "$GROUPER_GSH_CHECK_USER" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_GSH_CHECK_USER=true"
      export GROUPER_GSH_CHECK_USER=true
    fi
    if [ -z "$GROUPER_GSH_USER" ] ; then
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_GSH_USER=tomcat"
      export GROUPER_GSH_USER=tomcat
    fi
    
    if [ -z "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_RUN_TOMCAT_NOT_SUPERVISOR=false"
      export GROUPER_RUN_TOMCAT_NOT_SUPERVISOR=false
    fi
    if [ "$GROUPER_RUN_TOMCAT_NOT_SUPERVISOR" = "true" ]; then
      # if we are not running supervisor then default to not chown dirs
      if [ -z "$GROUPER_CHOWN_DIRS" ] ; then 
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_CHOWN_DIRS=false"
        export GROUPER_CHOWN_DIRS=false
      fi
    fi
    if [ -z "$GROUPER_CHOWN_DIRS" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_CHOWN_DIRS=true"
      export GROUPER_CHOWN_DIRS=true
    fi
    if [ -z "$GROUPER_TOMCAT_HTTP_PORT" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_TOMCAT_HTTP_PORT=8080"
      export GROUPER_TOMCAT_HTTP_PORT=8080
    fi
    if [ -z "$GROUPER_TOMCAT_MAX_HEADER_COUNT" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_TOMCAT_MAX_HEADER_COUNT=200"
      export GROUPER_TOMCAT_MAX_HEADER_COUNT=200
    fi
    if [ -z "$GROUPER_TOMCAT_AJP_PORT" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_TOMCAT_AJP_PORT=8009"
      export GROUPER_TOMCAT_AJP_PORT=8009
    fi
    if [ -z "$GROUPER_TOMCAT_SHUTDOWN_PORT" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_TOMCAT_SHUTDOWN_PORT=8005"
      export GROUPER_TOMCAT_SHUTDOWN_PORT=8005
    fi
    
    if [ -z "$GROUPER_SHIB_LOG_USE_PIPE" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_SHIB_LOG_USE_PIPE=true"
      export GROUPER_SHIB_LOG_USE_PIPE=true
    fi
    
    if [ -z "$GROUPER_APACHE_STATUS_PATH" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) export GROUPER_APACHE_STATUS_PATH=/status_grouper/status"
      export GROUPER_APACHE_STATUS_PATH=/status_grouper/status
    fi
    
    #Replace web.xml session timeout with env variable
    if [[ -z "$GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES" ]]; then
      if [[ "$GROUPER_UI" != 'true' ]] && [[ "$GROUPER_WS" = 'true' ]]; then
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) $ GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES is not set, export GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES=1"
        export GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES=1
      else
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishBegin) $ GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES is not set, export GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES=600 (10 hours)"
        export GROUPER_TOMCAT_SESSION_TIMEOUT_MINUTES=600
      
      fi
    fi
}

prep_finishEnd() {

    # defaults after the "only" part
    if [ -z "$GROUPER_TOMCAT_CONTEXT" ] ; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_TOMCAT_CONTEXT=grouper"
      export GROUPER_TOMCAT_CONTEXT=grouper
    fi
    if [ -z "$GROUPER_LOG_PREFIX" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_LOG_PREFIX=grouper"
      export GROUPER_LOG_PREFIX=grouper
    fi
    if [ -z "$GROUPER_MAX_MEMORY" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_MAX_MEMORY=1500m"
      export GROUPER_MAX_MEMORY=1500m
    fi
    if [ -z "$GROUPER_CONTEXT_COOKIES" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_CONTEXT_COOKIES=true"
      export GROUPER_CONTEXT_COOKIES=true
    fi
    if [ -z "$GROUPER_PUT_JAVA_HOME_IN_BASHRC" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_PUT_JAVA_HOME_IN_BASHRC=true"
      export GROUPER_PUT_JAVA_HOME_IN_BASHRC=true
    fi
    if [ -z "$GROUPER_JAVA_HOME" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto"
      export GROUPER_JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
    fi
    if [ -z "$GROUPER_TOMCAT_LOG_ACCESS" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_TOMCAT_LOG_ACCESS=false"
      export GROUPER_TOMCAT_LOG_ACCESS=false
    fi
    if [ "$GROUPER_RUN_SHIB_SP" = "true" ] && [ -z "$GROUPERUI_LOGOUT_REDIRECTTOURL" ]; then 
      echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPERUI_LOGOUT_REDIRECTTOURL=/Shibboleth.sso/Logout"
      export GROUPERUI_LOGOUT_REDIRECTTOURL=/Shibboleth.sso/Logout
    fi
    if [ -z "$GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER" ]; then 
      if [ "$GROUPER_PROXY_PASS" = "#" ]; then 
    
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER=false"
        export GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER=false
      else
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finishEnd) export GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER=true"
        export GROUPER_REDIRECT_FROM_SLASH_TO_GROUPER=true
      
      fi
    
    fi

}

prep_finish() {

    if [ "$GROUPER_SETUP_FILES_COMPLETE" = "true" ]
      then
        echo "grouperContainer; INFO: (libraryPrep.sh-prep_finish) GROUPER_SETUP_FILES_COMPLETE=true, skipping startup prep"
        prep_unsetAllAndFromFiles
        
        return
    fi

    grouperScriptHooks_prepComponentPost

    prep_finishBegin

    prepOnly    

    prep_runScim
    prep_runUi
    prep_runWs

    prep_finishEnd
    
    grouperScriptHooks_finishPrepPost
        
    prep_unsetAllAndFromFiles
    echo "grouperContainer; INFO: (libraryPrep.sh-prep_finish) End prep"
}

prep_unsetAllAndFromFiles() {
    prep_unsetAll
    prepOnly_unsetAll
}

prep_unsetAll() {
  unset -f prep_conf
  unset -f prep_daemon
  unset -f prep_finish
  unset -f prep_finishBegin
  unset -f prep_finishEnd
  unset -f prep_initDeprecatedEnvVars
  unset -f prep_openshift
  unset -f prep_quickstart
  unset -f prep_runScim
  unset -f prep_runUi
  unset -f prep_runWs
  unset -f prep_scim
  unset -f prep_unsetAll
  unset -f prep_unsetAllAndFromFiles
  unset -f prep_ui
  unset -f prep_ws
  
}

prep_exportAll() {
  export -f prep_conf
  export -f prep_daemon
  export -f prep_finish
  export -f prep_finishBegin
  export -f prep_finishEnd
  export -f prep_initDeprecatedEnvVars
  export -f prep_openshift
  export -f prep_quickstart
  export -f prep_runScim
  export -f prep_runUi
  export -f prep_runWs
  export -f prep_scim
  export -f prep_unsetAll
  export -f prep_unsetAllAndFromFiles
  export -f prep_ui
  export -f prep_ws
}

# export everything
prep_exportAll

