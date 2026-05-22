export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export OZONE_LOG_DIR="/var/log/hadoop"

# export OZONE_OPTS=
# export HADOOP_OPTS="-Dsun.security.krb5.debug=true"
# export OZONE_OPTS="-Djava.net.preferIPv4Stack=true -Dsun.security.krb5.debug=true -Dsun.security.spnego.debug=true"
# export KRB5_TRACE=/dev/stdout
# export HADOOP_JAAS_DEBUG=true

export OZONE_GC_SETTINGS="-XX:ParallelGCThreads=8"
export OZONE_OM_OPTS="-Xmx2g ${OZONE_GC_SETTINGS}"
export OZONE_SCM_OPTS="-Xmx2g ${OZONE_GC_SETTINGS}"
export OZONE_DATANODE_OPTS="-Xmx2g ${OZONE_GC_SETTINGS}"
