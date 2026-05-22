#!/bin/bash
#
# FUNCTION: Copy server's configs to local
#

for f in core-site.xml hadoop-env.sh \
	ozone-env.sh ozone-site.xml \
	ldap_bind_password.txt hdfs-site.xml hdfs_jaas.conf \
	ssl-server.xml ssl-client.xml yarn-site.xml mapred-site.xml yarn-env.sh \
	kms-site.xml kms-env.sh kms_jaas.conf \
; do \
  sudo install -o root -g root -m 0644 env/${f?} ${HADOOP_CONF_DIR}/${f?}; \
done

for f in hive-site.xml hive-env.sh hive_jaas.conf beeline-site.xml; do \
  sudo install -o root -g root -m 0644 env/${f?} ${HIVE_HOME}/conf/${f?}; \
done

for f in hadoop.sh ozone.sh hive.sh spark.sh hbase.sh; do \
  sudo install -o root -g root -m 0644 env/${f?} /etc/profile.d/${f?}; \
done

for f in spark-env.sh spark-defaults.conf; do \
  sudo install -o root -g root -m 0644 env/${f?} ${SPARK_HOME}/conf/${f?}; \
done

for f in tez-site.xml; do \
  sudo install -o root -g root -m 0644 env/${f?} ${TEZ_CONF_DIR}/${f?}; \
done

for f in hbase-site.xml hbase-env.sh hbase_jaas.conf regionservers backup-masters \
; do \
  sudo install -o root -g root -m 0644 env/${f?} ${HBASE_CONF_DIR}/${f?}; \
done
