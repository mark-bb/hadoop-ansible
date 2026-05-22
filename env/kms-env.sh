export KMS_TEMP=/tmp/kms
export KRB5CCNAME=/tmp/krb5cc_kms
kinit -kt /etc/security/keytabs/kms.keytab kms/astra181-scylla-01.internal@DOMAIN.COM
export KRB5_TRACE=/dev/stdout
export HADOOP_JAAS_DEBUG=true
export HADOOP_OPTS="${HADOOP_OPTS}
-Dsun.security.krb5.debug=true
-Dsun.security.spnego.debug=true
-Djavax.security.auth.useSubjectCredsOnly=false
-Djava.security.auth.login.config=/opt/hadoop/etc/hadoop/kms_jaas.conf
-Dzookeeper.sasl.clientconfig=ZKSignerSecretProviderClient
-Dzookeeper.client.secure=true
-Dzookeeper.clientCnxnSocket=org.apache.zookeeper.ClientCnxnSocketNetty
-Dzookeeper.ssl.keyStore.location=/etc/security/certs/keystore.jks
-Dzookeeper.ssl.keyStore.type=JKS
-Dzookeeper.ssl.keyStore.password=passw0rd
-Dzookeeper.ssl.trustStore.location=/etc/security/certs/truststore.jks
-Dzookeeper.ssl.trustStore.type=JKS
-Dzookeeper.ssl.trustStore.password=passw0rd
"
