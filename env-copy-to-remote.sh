#!/bin/bash
#
# FUNCTION: Copy server's configs to local
#

pssh='/home/mbarinstein/pssh/.venv/bin/pssh'
for f in workers core-site.xml hadoop-env.sh ozone-env.sh ozone-site.xml ldap_bind_password.txt hdfs-site.xml ssl-server.xml ssl-client.xml yarn-site.xml mapred-site.xml yarn-env.sh; do \
  # ${pssh} -i -h machines.txt -- sudo sh -lc \"echo install -o root -g root -m 0644 /dev/stdin \\\${HADOOP_CONF_DIR}/${f?}\"; \
  cat env/${f?} | ${pssh?} -I -i -h machines.txt -- sudo sh -lc \"install -o root -g root -m 0644 /dev/stdin \\\${HADOOP_CONF_DIR}/${f?}\"; \
done

#for f in hadoop.sh ozone.sh; do \
#  sudo install -o root -g root -m 0644 env/${f?} /etc/profile.d/${f?}; \
#done
