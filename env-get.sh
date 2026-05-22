#!/bin/bash
#
# FUNCTION: Copy remote hadoop config to local directory
#

e=$(grep 01 machines.txt)

for f in workers core-site.xml hadoop-env.sh \
	ozone-env.sh ozone-site.xml \
	ldap_bind_password.txt hdfs-site.xml hdfs_jaas.conf ssl-server.xml ssl-client.xml \
	kms-site.xml kms-env.sh kms_jaas.conf \
	yarn-site.xml mapred-site.xml yarn-env.sh \
; do \
  ssh ${e?} -- sudo sh -lc \"cat \\\${HADOOP_CONF_DIR}/${f?}\" > env/${f?}; \
done

for f in hive-site.xml hive-env.sh hive_jaas.conf beeline-site.xml \
; do \
  ssh ${e?} -- sudo sh -lc \"cat \\\${HIVE_HOME}/conf/${f?}\" > env/${f?}; \
done

for f in hadoop.sh ozone.sh hive.sh spark.sh hbase.sh; do \
  ssh ${e?} -- cat /etc/profile.d/${f?} > env/${f?}; \
done

f=kms.keystore
ssh ${e?} -- sudo sh -c \"cat \~hadoop/${f?}\" > env/${f?} 

for f in spark-env.sh spark-defaults.conf; do \
  ssh ${e?} -- sudo sh -lc \"cat \\\${SPARK_HOME}/conf/${f?}\" > env/${f?}; \
done

for f in tez-site.xml; do \
  ssh ${e?} -- sudo sh -lc \"cat \\\${TEZ_CONF_DIR}/${f?}\" > env/${f?}; \
done

for f in hbase-site.xml hbase-env.sh hbase_jaas.conf regionservers backup-masters \
; do \
  ssh ${e?} -- sudo sh -lc \"cat \\\${HBASE_HOME}/conf/${f?}\" > env/${f?}; \
done
