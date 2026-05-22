export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
export HADOOP_INSTALL=${HADOOP_HOME}
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export HADOOP_YARN_HOME=${HADOOP_HOME}
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native
export HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib/native"
export HADOOP_LOG_DIR="/var/log/hadoop"
export HADOOP_OPTIONAL_TOOLS="hadoop-aws"
export HDFS_ZKFC_OPTS="
-Djavax.security.auth.useSubjectCredsOnly=false
-Djava.security.auth.login.config=/opt/hadoop/etc/hadoop/hdfs_jaas.conf
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
-Dzookeeper.client.secure=true
-Dzookeeper.ssl.keyStore.location=/etc/security/certs/keystore.jks
-Dzookeeper.ssl.keyStore.type=JKS
-Dzookeeper.ssl.keyStore.password=passw0rd
-Dzookeeper.ssl.trustStore.location=/etc/security/certs/truststore.jks
-Dzookeeper.ssl.trustStore.type=JKS
-Dzookeeper.ssl.trustStore.password=passw0rd
"
export TEZ_HOME="/opt/tez"
export TEZ_JARS=${TEZ_HOME}
export TEZ_CONF_DIR=${TEZ_HOME}/conf
export HADOOP_CLASSPATH=${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*:${HADOOP_CLASSPATH}
