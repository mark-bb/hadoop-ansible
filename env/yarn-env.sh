export HADOOP_LOG_DIR="/var/log/hadoop"
export HADOOP_OPTS="${HADOOP_OPTS}
-Djava.library.path=/opt/hadoop/lib/native
-Djavax.security.auth.useSubjectCredsOnly=false
-Djava.security.auth.login.config=/opt/hadoop/etc/hadoop/yarn_jaas.conf
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
-Dzookeeper.client.secure=true
-Dzookeeper.ssl.keyStore.location=/etc/security/certs/keystore.jks
-Dzookeeper.ssl.keyStore.type=JKS
-Dzookeeper.ssl.keyStore.password=passw0rd
-Dzookeeper.ssl.trustStore.location=/etc/security/certs/truststore.jks
-Dzookeeper.ssl.trustStore.type=JKS
-Dzookeeper.ssl.trustStore.password=passw0rd
"

