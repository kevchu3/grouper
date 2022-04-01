CLASSPATH=/opt/tomee/bin/*
#JAVA_OPTS="-Dlog4j.configurationFile=/opt/tomee/conf/log4j2.xml -DENV=$ENV -DUSERTOKEN=$USERTOKEN"
CATALINA_OPTS="-Xmx$GROUPER_MAX_MEMORY -XX:+UseG1GC -XX:+UseStringDeduplication -Dlog4j.configurationFile=/opt/tomee/conf/log4j2.xml -DENV=$ENV -DUSERTOKEN=$USERTOKEN -Dfile.encoding=UTF-8 $GROUPER_EXTRA_CATALINA_OPTS"
LOGGING_MANAGER=-Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
