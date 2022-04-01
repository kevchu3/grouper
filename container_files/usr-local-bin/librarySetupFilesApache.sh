#!/bin/bash

setupFilesApache_indexes() {
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ "$GROUPER_APACHE_DIRECTORY_INDEXES" = "false" ]
    then
      if [ "$GROUPER_ORIGFILE_HTTPD_CONF" = "true" ]; then
        # take out the directory indexes from the docroot
        cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.pre_noindexes
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_indexes) cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.pre_noindexes, result: $returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
        
        patch /etc/httpd/conf/httpd.conf /etc/httpd/conf.d/httpd.conf.noindexes.patch
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_indexes) Patch httpd.conf to turn off indexes 'patch /etc/httpd/conf/httpd.conf /etc/httpd/conf.d/httpd.conf.noindexes.patch' result=$returnCode"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else
        echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_indexes) /etc/httpd/conf/httpd.conf is not the original file so will not be changed"
      fi
  fi

}

setupFilesApache_ssl() {
    if [ "$GROUPER_RUN_APACHE" = "true" ] && [ "$GROUPER_USE_SSL" != "true" ]
       then
       if [ -f /etc/httpd/conf.d/ssl.conf ]
         then
           mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.dontuse
           returnCode=$?
           echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ssl) mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.dontuse , result: $?"
           if [ $returnCode != 0 ]; then exit $returnCode; fi
       fi
       if [ -f /etc/httpd/conf.d/ssl-enabled.conf ]
         then
           mv -v /etc/httpd/conf.d/ssl-enabled.conf /etc/httpd/conf.d/ssl-enabled.conf.dontuse
           returnCode=$?
           echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ssl) mv -v /etc/httpd/conf.d/ssl-enabled.conf /etc/httpd/conf.d/ssl-enabled.conf.dontuse , result: $?"
           if [ $returnCode != 0 ]; then exit $returnCode; fi
       fi
    fi
    if [ "$GROUPER_RUN_APACHE" = "true" ] && [ "$GROUPER_USE_SSL" = "true" ] && [ -f /etc/httpd/conf.d/ssl-enabled.conf ] && [ "$GROUPER_ORIGFILE_SSL_ENABLED_CONF" = "true" ] ; then
    
      if [ "$GROUPER_SSL_USE_STAPLING" = "true" ]; then
        sed -i "s|__GROUPER_SSL_USE_STAPLING__|on|g" /etc/httpd/conf.d/ssl-enabled.conf
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ports) sed -i \"s|__GROUPER_SSL_USE_STAPLING__|on|g\" /etc/httpd/conf.d/ssl-enabled.conf , result: $?"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      else 
        sed -i "s|__GROUPER_SSL_USE_STAPLING__|off|g" /etc/httpd/conf.d/ssl-enabled.conf
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ports) sed -i \"s|__GROUPER_SSL_USE_STAPLING__|on|g\" /etc/httpd/conf.d/ssl-enabled.conf , result: $?"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
      
      fi

      sed -i "s|__GROUPER_SSL_CERT_FILE__|$GROUPER_SSL_CERT_FILE|g" /etc/httpd/conf.d/ssl-enabled.conf
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ports) Set cert file: sed -i \"s|SSLCertificateChainFile __GROUPER_SSL_CERT_FILE__|$GROUPER_SSL_CERT_FILE|g\" /etc/httpd/conf.d/ssl-enabled.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
      sed -i "s|__GROUPER_SSL_KEY_FILE__|$GROUPER_SSL_KEY_FILE|g" /etc/httpd/conf.d/ssl-enabled.conf
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ports) Set cert file: sed -i \"s|SSLCertificateChainFile __GROUPER_SSL_KEY_FILE__|$GROUPER_SSL_KEY_FILE|g\" /etc/httpd/conf.d/ssl-enabled.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
      
      if [ "$GROUPER_SSL_USE_CHAIN_FILE" = "true" ]; then

        sed -i "s|__GROUPER_SSL_CHAIN_FILE__|$GROUPER_SSL_CHAIN_FILE|g" /etc/httpd/conf.d/ssl-enabled.conf
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ports) No chain setting: sed -i \"s|SSLCertificateChainFile __GROUPER_SSL_CHAIN_FILE__|$GROUPER_SSL_CHAIN_FILE|g\" /etc/httpd/conf.d/ssl-enabled.conf , result: $?"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
        
    
      else
        sed -i "s|SSLCertificateChainFile __GROUPER_SSL_CHAIN_FILE__||g" /etc/httpd/conf.d/ssl-enabled.conf
        returnCode=$?
        echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ports) No chain setting: sed -i \"s|SSLCertificateChainFile __GROUPER_SSL_CHAIN_FILE__||g\" /etc/httpd/conf.d/ssl-enabled.conf , result: $?"
        if [ $returnCode != 0 ]; then exit $returnCode; fi
    
      fi
    
    fi
}



setupFilesApache_serverName() {
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ ! -z "$GROUPER_APACHE_SERVER_NAME" ] && [ "$GROUPER_APACHE_SERVER_NAME" != "" ] && [ -f /etc/httpd/conf.d/grouper-www.conf ]
    then
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_serverName) Appending ServerName to grouper-www.conf"
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "ServerName $GROUPER_APACHE_SERVER_NAME" >> /etc/httpd/conf.d/grouper-www.conf
      echo "UseCanonicalName On" >> /etc/httpd/conf.d/grouper-www.conf
      echo >> /etc/httpd/conf.d/grouper-www.conf
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_serverName) Setup ServerName $GROUPER_APACHE_SERVER_NAME in /etc/httpd/conf.d/grouper-www.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesApache_remoteip() {
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ ! -z "$GROUPER_APACHE_REMOTE_IP_HEADER" ] && [ "$GROUPER_APACHE_REMOTE_IP_HEADER" != "" ] && [ -f /etc/httpd/conf.d/grouper-www.conf ]
    then
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_remoteip) Appending RemoteIPHeader to grouper-www.conf"
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "RemoteIPHeader $GROUPER_APACHE_REMOTE_IP_HEADER" >> /etc/httpd/conf.d/grouper-www.conf
      returnCode=$?
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_remoteip) echo \"RemoteIPHeader $GROUPER_APACHE_REMOTE_IP_HEADER\" >> /etc/httpd/conf.d/grouper-www.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ ! -z "$GROUPER_APACHE_REMOTE_IP_TRUSTED_PROXY" ] && [ "$GROUPER_APACHE_REMOTE_IP_TRUSTED_PROXY" != "" ] && [ -f /etc/httpd/conf.d/grouper-www.conf ]
    then
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_remoteip) Appending RemoteIPTrustedProxy to grouper-www.conf"
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "RemoteIPTrustedProxy $GROUPER_APACHE_REMOTE_IP_TRUSTED_PROXY" >> /etc/httpd/conf.d/grouper-www.conf
      returnCode=$?
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_remoteip) echo \"RemoteIPTrustedProxy $GROUPER_APACHE_REMOTE_IP_TRUSTED_PROXY\" >> /etc/httpd/conf.d/grouper-www.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ ! -z "$GROUPER_APACHE_REMOTE_IP_INTERNAL_PROXY" ] && [ "$GROUPER_APACHE_REMOTE_IP_INTERNAL_PROXY" != "" ] && [ -f /etc/httpd/conf.d/grouper-www.conf ]
    then
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_remoteip) Appending RemoteIPInternalProxy to grouper-www.conf"
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "RemoteIPInternalProxy $GROUPER_APACHE_REMOTE_IP_INTERNAL_PROXY" >> /etc/httpd/conf.d/grouper-www.conf
      returnCode=$?
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_remoteip) echo \"RemoteIPInternalProxy $GROUPER_APACHE_REMOTE_IP_INTERNAL_PROXY\" >> /etc/httpd/conf.d/grouper-www.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesApache_status() {
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ ! -z "$GROUPER_APACHE_STATUS_PATH" ] && [ "$GROUPER_APACHE_STATUS_PATH" != "" ] && [ "$GROUPER_APACHE_STATUS_PATH" != "none" ] && [ -f /etc/httpd/conf.d/grouper-www.conf ]
    then
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_status) Appending status to grouper-www.conf"
      echo >> /etc/httpd/conf.d/grouper-www.conf
      # ProxyPass /status_grouper/status ajp://localhost:8009/grouper/status timeout=2401
      echo "ProxyPass $GROUPER_APACHE_STATUS_PATH ajp://localhost:$GROUPER_TOMCAT_AJP_PORT/$GROUPER_TOMCAT_CONTEXT/status timeout=2401" >> /etc/httpd/conf.d/grouper-www.conf
      returnCode=$?
      echo >> /etc/httpd/conf.d/grouper-www.conf
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_status) echo \"ProxyPass $GROUPER_APACHE_STATUS_PATH ajp://localhost:$GROUPER_TOMCAT_AJP_PORT/$GROUPER_TOMCAT_CONTEXT/status timeout=2401\" >> /etc/httpd/conf.d/grouper-www.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi
}

setupFilesApache_supervisor() {
  if [ "$GROUPER_RUN_APACHE" = "true" ]
    then
      cat /opt/tier-support/supervisord-httpd.conf >> /opt/tier-support/supervisord.conf
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_supervisor) cat /opt/tier-support/supervisord-httpd.conf >> /opt/tier-support/supervisord.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}

setupFilesApache_ports() {

  # filter the ssl config for ssl port
  
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ -f /etc/httpd/conf.d/ssl-enabled.conf ] && [ "$GROUPER_ORIGFILE_SSL_ENABLED_CONF" = "true" ]
    then
      sed -i "s|__GROUPER_APACHE_SSL_PORT__|$GROUPER_APACHE_SSL_PORT|g" /etc/httpd/conf.d/ssl-enabled.conf
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ports) sed -i \"s|__GROUPER_APACHE_SSL_PORT__|$GROUPER_APACHE_SSL_PORT|g\" /etc/httpd/conf.d/ssl-enabled.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi
  
  if [ "$GROUPER_RUN_APACHE" = "true" ] && [ "$GROUPER_APACHE_NONSSL_PORT" != "80" ]
    then
      sed -i "s|Listen 80|Listen $GROUPER_APACHE_NONSSL_PORT|g" /etc/httpd/conf/httpd.conf
      returnCode=$?
      echo "grouperContainer; INFO: (librarySetupFilesApache.sh-setupFilesApache_ports) Replace apache non-ssl port in httpd.conf, sed -i \"s|Listen 80|Listen $GROUPER_APACHE_NONSSL_PORT|g\" /etc/httpd/conf/httpd.conf , result: $?"
      if [ $returnCode != 0 ]; then exit $returnCode; fi
  fi

}


setupFilesApache() {
  setupFilesApache_supervisor
  setupFilesApache_ports
  setupFilesApache_remoteip
  setupFilesApache_ssl
  setupFilesApache_status
  setupFilesApache_serverName
  setupFilesApache_indexes
}

setupFilesApache_unsetAll() {
  unset -f setupFilesApache
  unset -f setupFilesApache_indexes
  unset -f setupFilesApache_ports
  unset -f setupFilesApache_remoteip
  unset -f setupFilesApache_ssl
  unset -f setupFilesApache_status
  unset -f setupFilesApache_supervisor
  unset -f setupFilesApache_unsetAll
  unset -f setupFilesApache_serverName
}

setupFilesApache_exportAll() {
  export -f setupFilesApache
  export -f setupFilesApache_indexes
  export -f setupFilesApache_ports
  export -f setupFilesApache_remoteip
  export -f setupFilesApache_ssl
  export -f setupFilesApache_status
  export -f setupFilesApache_supervisor
  export -f setupFilesApache_unsetAll
  export -f setupFilesApache_serverName
}

# export everything
setupFilesApache_exportAll


