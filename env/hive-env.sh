export HADOOP_HEAPSIZE=2048
export HIVESERVER2_PID_DIR=/var/run/hive
export HADOOP_CLIENT_OPTS="${HADOOP_CLIENT_OPTS}
-Djavax.security.auth.useSubjectCredsOnly=false
-Djava.security.auth.login.config=/opt/hive/conf/hive_jaas.conf
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
-Dzookeeper.client.secure=true
-Dzookeeper.ssl.keyStore.location=/etc/security/certs/keystore.jks
-Dzookeeper.ssl.keyStore.type=JKS
-Dzookeeper.ssl.keyStore.password=passw0rd
-Dzookeeper.ssl.trustStore.location=/etc/security/certs/truststore.jks
-Dzookeeper.ssl.trustStore.type=JKS
-Dzookeeper.ssl.trustStore.password=passw0rd
-Dzookeeper.sasl.clientconfig=Client
"
