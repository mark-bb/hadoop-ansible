# Hadoop [un]installing

With HDFS or Ozone, Hive, Spark.


## Notes
- The only playbok at the moment is `hadoop.yml` 
- Playbook uses common variables in `group_vars/all/set-env.yml`
- The `java_home` variable must be specified correctly. The playbook doesn't install java jdk/jre and fails, if the `bin/java` executable doesn't exist
```
grep '^java_home:' group_vars/all/set-env.yml
java_home: "/usr/lib/jvm/java-11-openjdk-amd64"
```
- Distributives & files must be placed to the `files/distrib` directory. Its current contents is:
```
tree files
files
└── distrib
    ├── apache-hive-4.0.0-bin.tar.gz -> /distrib/hive/apache-hive-4.0.0-bin.tar.gz
    ├── hadoop-3.3.6.tar.gz -> /distrib/hadoop/hadoop-3.3.6.tar.gz
    ├── ozone-1.4.0.tar.gz -> /distrib/ozone/ozone-1.4.0.tar.gz
    ├── postgresql-42.5.6.jar
    └── spark-3.5.1-bin-hadoop3.tgz -> /distrib/spark/spark-3.5.1-bin-hadoop3.tgz
```
One may find them in the `10.0.100.149:/distrib/{hadoop,ozone,hive,postgresql}` ftp directories, for example.
- Components placement.  
The inventory file has the following structure:
```
[hadoop:children]
hadoop_namenodes
hadoop_datanodes

[hadoop_namenodes]
fqdn-namenode1
...
fqdn-namenodeX

[hadoop_datanodes]
fqdn-datanode1
...
fqdn-datanodeY
```
The 1-st namenode (`fqdn-namenode1` in the example) is currently used as Yarn RM, Application / Job History Servers, Hive Metastore and Hiveserver2, Spark History Server. Such a use can be changed with the corresponding variables.
- Selection between HDFS and OZONE is done with the `with_hdfs` and `with_ozone` variables. One and only one of these variables can be set to "yes".
- During the installation of OZONE, HDFS, HIVE some initialization actions are used, and they must be done only once. Execution of these actions is controlled by the `<component>_config_only` variables having defalut values `"yes"`. So you run the corresponding tasks setting these variables to `"no"` explicitly initially, and don't use them again if the corresponding tasks are completed successfully.
- Running tasks without use of `<component>_config_only` variable means "stop", "apply new config", "start" if the corresponding actions are applicable. Just "stop/start" is controlled with the `play_action` environment variable (see the examples).
- POSTGRESQL database is used for Hive Metastore Server. The playbook doesn't install and configure it. You must specify the corresponding parameters like in the `roles/hive/defaults/main.yml` file.
```
hive_jdo_ConnectionURL: "jdbc:postgresql://click-01.vm.stsoft.lan:5432,click-02.vm.stsoft.lan:5432,click-03.vm.stsoft.lan:5432/hivemetastore_sastra?targetServerType=primary"
hive_jdo_ConnectionDriverName: "org.postgresql.Driver"
hive_jdo_ConnectionUserName: "hive_sastra"
hive_jdo_ConnectionPassword: "passw0rd"
```
The database can be created with the folloing PG commands:
```
CREATE DATABASE hivemetastore_sastra;
CREATE ROLE hive_sastra with encrypted password 'passw0rd' login;
GRANT ALL ON DATABASE hivemetastore_sastra TO hive_sastra;
--Since PG 15 while connected to hivemetastore_sastra 
GRANT ALL ON schema public TO hive_sastra;
```

## Commands examples
- Installing all the comonents
```
ansible-playbook hadoop.yml \
-e 'hdfs_config_only=no' \
-e 'hive_config_only=no' \
-e 'spark_config_only=no'
```
- Installing by components
```
ansible-playbook hadoop.yml -t hadoop
ansible-playbook hadoop.yml -t hdfs  -e 'hdfs_config_only=no' 
ansible-playbook hadoop.yml -t ozone -e 'ozone_config_only=no' 
ansible-playbook hadoop.yml -t hive  -e 'hive_config_only=no'
ansible-playbook hadoop.yml -t spark -e 'spark_config_only=no'
```
- Stop a component
```
ansible-playbook hadoop.yml -t hive -e 'play_action=stop'
```
- Start a component
```
ansible-playbook hadoop.yml -t hive -e 'play_action=start'
```
## URLs
**HDFS**  
http://fqdn-namenode1:9870  
http://fqdn-namenode2:9870  
http://fqdn-namenode3:9870  

**OZONE**
- Ozone Manager:  
http://fqdn-namenode1:9874  
http://fqdn-namenode2:9874  
http://fqdn-namenode3:9874  
- Ozone Recon: http://fqdn-namenode1:9888
- Ozone HTTPFS: http://fqdn-namenode1:14000/webhdfs/v1?op=gethomedirectory&user.name=hdfs

**Common**
- HiveServer2: http://fqdn-namenode1:10002
- Spark History: http://fqdn-namenode1:18080
- Yarn RM: http://fqdn-namenode1:8088
- Yarn Timeline (App History) Server: http://fqdn-namenode1:8188
- MR History (Job History) Server: http://fqdn-namenode1:19888
- Yarn NM:  
http://fqdn-namenode1:8042  
http://fqdn-namenode1:8042  
http://fqdn-namenode1:8042  


## Useful commands  
- Info on all `hadoop` or `hive` user processes running on the 1-st namenode
```
user=hive
user=hadoop

ansible -m shell -a "ps -u ${user?} -o pid,args || true" $(grep -A1 hadoop_namenodes inv | tail -1)
```
`hadoop` example:
```
VTB-Scylla-astra-05.vm.stsoft.lan | CHANGED | rc=0 >>
 6666 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_historyserver -Djava.library.path=/opt/hadoop/lib/native -Dmapred.jobsummary.logger=INFO,RFA -Dyarn.log.dir=/var/log/hadoop -Dyarn.log.file=hadoop-hadoop-historyserver-VTB-Scylla-astra-05.log -Dyarn.home.dir=/opt/hadoop -Dyarn.root.logger=INFO,console -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=hadoop-hadoop-historyserver-VTB-Scylla-astra-05.log -Dhadoop.home.dir=/opt/hadoop -Dhadoop.id.str=hadoop -Dhadoop.root.logger=INFO,RFA -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.hadoop.mapreduce.v2.hs.JobHistoryServer
 6982 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_resourcemanager -Djava.library.path=/opt/hadoop/lib/native -Dservice.libdir=/opt/hadoop/share/hadoop/yarn,/opt/hadoop/share/hadoop/yarn/lib,/opt/hadoop/share/hadoop/hdfs,/opt/hadoop/share/hadoop/hdfs/lib,/opt/hadoop/share/hadoop/common,/opt/hadoop/share/hadoop/common/lib -Dyarn.log.dir=/var/log/hadoop -Dyarn.log.file=hadoop-hadoop-resourcemanager-VTB-Scylla-astra-05.log -Dyarn.home.dir=/opt/hadoop -Dyarn.root.logger=INFO,console -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=hadoop-hadoop-resourcemanager-VTB-Scylla-astra-05.log -Dhadoop.home.dir=/opt/hadoop -Dhadoop.id.str=hadoop -Dhadoop.root.logger=INFO,RFA -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
 7376 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_timelineserver -Djava.library.path=/opt/hadoop/lib/native -Dyarn.log.dir=/var/log/hadoop -Dyarn.log.file=hadoop-hadoop-timelineserver-VTB-Scylla-astra-05.log -Dyarn.home.dir=/opt/hadoop -Dyarn.root.logger=INFO,console -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=hadoop-hadoop-timelineserver-VTB-Scylla-astra-05.log -Dhadoop.home.dir=/opt/hadoop -Dhadoop.id.str=hadoop -Dhadoop.root.logger=INFO,RFA -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.hadoop.yarn.server.applicationhistoryservice.ApplicationHistoryServer
 8605 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -cp /opt/spark/conf/:/opt/spark/jars/*:/opt/hadoop/etc/hadoop/ -Xmx1g org.apache.spark.deploy.history.HistoryServer
28094 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_scm -Dlog4j2.contextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector -Dorg.apache.ratis.thirdparty.io.netty.allocator.useCacheForAllThreads=false -Xmx8g -XX:ParallelGCThreads=8 -Dlog4j.configurationFile=/opt/ozone/etc/hadoop/scm-audit-log4j2.properties --add-opens java.base/java.nio=ALL-UNNAMED -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=ozone-hadoop-scm-VTB-Scylla-astra-05.log -Dhadoop.home.dir=/opt/ozone -Dhadoop.id.str=hadoop -Dhadoop.root.logger=INFO,RFA -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.hadoop.hdds.scm.server.StorageContainerManagerStarter
28734 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_om -Dlog4j2.contextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector -Dorg.apache.ratis.thirdparty.io.netty.allocator.useCacheForAllThreads=false -Xmx8g -XX:ParallelGCThreads=8 -Dlog4j.configurationFile=/opt/ozone/etc/hadoop/om-audit-log4j2.properties --add-opens java.base/java.nio=ALL-UNNAMED -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=ozone-hadoop-om-VTB-Scylla-astra-05.log -Dhadoop.home.dir=/opt/ozone -Dhadoop.id.str=hadoop -Dhadoop.root.logger=INFO,RFA -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.hadoop.ozone.om.OzoneManagerStarter
29569 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_httpfs -Dhttpfs.home.dir=/opt/ozone -Dhttpfs.config.dir=/opt/ozone/etc/hadoop -Dhttpfs.log.dir=/opt/ozone/log -Dhttpfs.temp.dir=/opt/ozone/temp --add-opens java.base/java.nio=ALL-UNNAMED -XX:ParallelGCThreads=8 -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=ozone-hadoop-httpfs-VTB-Scylla-astra-05.log -Dhadoop.home.dir=/opt/ozone -Dhadoop.id.str=hadoop -Dhadoop.root.logger=INFO,RFA -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.ozone.fs.http.server.HttpFSServerWebServer
29693 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_recon --add-opens java.base/java.nio=ALL-UNNAMED -XX:ParallelGCThreads=8 -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=ozone-hadoop-recon-VTB-Scylla-astra-05.log -Dhadoop.home.dir=/opt/ozone -Dhadoop.id.str=hadoop -Dhadoop.root.logger=INFO,RFA -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.hadoop.ozone.recon.ReconServer
```
`hive` example:
```
VTB-Scylla-astra-05.vm.stsoft.lan | CHANGED | rc=0 >>
 5212 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_jar -Djava.library.path=/opt/hadoop/lib/native -Dproc_metastore -Dlog4j.configurationFile=hive-log4j2.properties -Djava.util.logging.config.file=/opt/hive/bin/../conf/parquet-logging.properties -Dyarn.log.dir=/var/log/hadoop -Dyarn.log.file=hadoop.log -Dyarn.home.dir=/opt/hadoop -Dyarn.root.logger=INFO,console -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=hadoop.log -Dhadoop.home.dir=/opt/hadoop -Dhadoop.id.str=hive -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.hadoop.util.RunJar /opt/hive/lib/hive-metastore-4.0.0.jar org.apache.hadoop.hive.metastore.HiveMetaStore
 5370 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Dproc_jar -Djava.library.path=/opt/hadoop/lib/native -Dproc_hiveserver2 -Dlog4j.configurationFile=hive-log4j2.properties -Djava.util.logging.config.file=/opt/hive/bin/../conf/parquet-logging.properties -Dyarn.log.dir=/var/log/hadoop -Dyarn.log.file=hadoop.log -Dyarn.home.dir=/opt/hadoop -Dyarn.root.logger=INFO,console -Dhadoop.log.dir=/var/log/hadoop -Dhadoop.log.file=hadoop.log -Dhadoop.home.dir=/opt/hadoop -Dhadoop.id.str=hive -Dhadoop.root.logger=INFO,console -Dhadoop.policy.file=hadoop-policy.xml -Dhadoop.security.logger=INFO,NullAppender org.apache.hadoop.util.RunJar /opt/hive/lib/hive-service-4.0.0.jar org.apache.hive.service.server.HiveServer2
```
- Ports are listened by a component. Set the corresponding couple of variables accordingly.
```
user=hadoop

srv=NameNode
srv=DataNode
srv=JournalNode

srv=OzoneManagerStarter
srv=ReconServer
srv=HttpFSServerWebServer
srv=HddsDatanodeService
srv=StorageContainerManagerStarter

srv=ResourceManager
srv=JobHistoryServer
srv=ApplicationHistoryServer
srv=.HistoryServer


user=hive
srv=HiveMetaStore
srv=HiveServer2

ansible -m shell -a "sudo netstat -nlp | grep \" \$(ps -u ${user?} -o pid= -o args= | grep -F ${srv?} | awk '{print \$1}')/\" || true" $(grep -A1 hadoop_namenodes inv | tail -1)
```
`hadoop` & `StorageContainerManagerStarter` example:
```
tcp6       0      0 :::9876                 :::*                    LISTEN      28094/java
tcp6       0      0 :::9863                 :::*                    LISTEN      28094/java
tcp6       0      0 :::9860                 :::*                    LISTEN      28094/java
tcp6       0      0 :::9861                 :::*                    LISTEN      28094/java
tcp6       0      0 :::9894                 :::*                    LISTEN      28094/java
tcp6       0      0 :::9895                 :::*                    LISTEN      28094/java
```
`hive` & `HiveServer2` example:
```
tcp6       0      0 :::10002                :::*                    LISTEN      5370/java
tcp6       0      0 :::10000                :::*                    LISTEN      5370/java
```
- Log files
```
ansible -m shell -a "sh -c 'ls -gGtr /var/log/hadoop/*.log'" $(grep -A1 hadoop_namenodes inv | tail -1)
```
OZONE example:
```
-rw-r--r-- 1   11075 июл  6 10:21 /var/log/hadoop/ozone-hadoop-httpfs-VTB-Scylla-astra-05.log
-rw-r--r-- 1 3723600 июл  6 16:24 /var/log/hadoop/hadoop-hadoop-resourcemanager-VTB-Scylla-astra-05.log
-rw-r--r-- 1  174543 июл  6 19:22 /var/log/hadoop/ozone-hadoop-om-VTB-Scylla-astra-05.log
-rw-r--r-- 1  113202 июл  6 19:40 /var/log/hadoop/hadoop-hadoop-timelineserver-VTB-Scylla-astra-05.log
-rw-r--r-- 1  121959 июл  6 19:42 /var/log/hadoop/hadoop-hadoop-historyserver-VTB-Scylla-astra-05.log
-rw-r--r-- 1  959675 июл  6 19:44 /var/log/hadoop/ozone-hadoop-recon-VTB-Scylla-astra-05.log
-rw-r--r-- 1  752986 июл  6 19:44 /var/log/hadoop/ozone-hadoop-scm-VTB-Scylla-astra-05.log
-rw-r--r-- 1 1069952 июл  6 19:44 /var/log/hadoop/om-audit-VTB-Scylla-astra-05.log
-rw-r--r-- 1 5102671 июл  6 19:45 /var/log/hadoop/scm-audit-VTB-Scylla-astra-05.log
```
So, one may get, say 100 last records for the corresponding component with the following:
```
comp=hadoop-hadoop-resourcemanager
comp=hadoop-hadoop-timelineserver
comp=hadoop-hadoop-historyserver
comp=om-audit
comp=scm-audit
comp=ozone-hadoop-httpfs
comp=ozone-hadoop-om
comp=ozone-hadoop-recon
comp=ozone-hadoop-scm

ansible -m shell -a "sh -c 'tail -100 /var/log/hadoop/${comp?}-*.log'" $(grep -A1 hadoop_namenodes inv | tail -1)
```
- Ozone SCM & OM roles
```
ansible -m shell -a "sudo -iu hadoop ozone admin scm roles" $(grep -A1 hadoop_namenodes inv | tail -1)

VTB-Scylla-astra-06.vm.stsoft.lan:9894:FOLLOWER:0f922681-0d9d-4dcf-90c5-69a57dd4c959:10.0.32.74
VTB-Scylla-astra-07.vm.stsoft.lan:9894:FOLLOWER:1696cb3d-7670-4235-b616-07daafc9e5fd:10.0.32.76
VTB-Scylla-astra-05.vm.stsoft.lan:9894:LEADER:82c70d6c-9155-4c36-bfd4-93476b5385e7:10.0.32.75


ansible -m shell -a "sudo -iu hadoop ozone admin om getserviceroles -id=omservice1" $(grep -A1 hadoop_namenodes inv | tail -1)

VTB-Scylla-astra-07 : FOLLOWER (VTB-Scylla-astra-07.vm.stsoft.lan)
VTB-Scylla-astra-06 : FOLLOWER (VTB-Scylla-astra-06.vm.stsoft.lan)
VTB-Scylla-astra-05 : LEADER (VTB-Scylla-astra-05.vm.stsoft.lan)
```
- HDFS  
Safe mode status on nodes:
```
ansible -m shell -a "sudo -iu hadoop hdfs dfsadmin -safemode get" $(grep -A1 hadoop_namenodes inv | tail -1)

Safe mode is OFF in VTB-Scylla-rhel-01.vm.stsoft.lan/10.0.32.67:8020
Safe mode is OFF in VTB-Scylla-rhel-02.vm.stsoft.lan/10.0.32.66:8020
Safe mode is OFF in VTB-Scylla-rhel-03.vm.stsoft.lan/10.0.32.59:8020
```
Get services state:
```
ansible -m shell -a "sudo -iu hadoop hdfs haadmin -ns nameservice1 -getAllServiceState" $(grep -A1 hadoop_namenodes inv | tail -1)

VTB-Scylla-rhel-01.vm.stsoft.lan:8020              active
VTB-Scylla-rhel-02.vm.stsoft.lan:8020              standby
VTB-Scylla-rhel-03.vm.stsoft.lan:8020              standby
```
## Uninstalling
**TBD**  

Users: `hadoop`, `hive`  
Group: `supergroup`

Code is installed to the directories pointed out by the `/opt/{hadoop,ozone,hive,spark}` links. All these directories (in `/opt` as well) and links can be removed.

Data directories (their current values):

Common (group_vars/all/set-env.yml):
```
hadoop_log_dir: "/var/log/hadoop"
hadoop_tmp_dir: "/tmp/hadoop-hadoop"
```
Hive log: `/tmp/hive/hive.log` 

HDFS (roles/hdfs/defaults/main.yml):  
```
hdfs_dfs_namenode_dir: "/data/nameNode"  
hdfs_dfs_datanode_dir: "/data/dataNode"  
hdfs_dfs_journalnode_dir: "/data/journalNode"  
```
OZONE (roles/ozone/defaults/main.yml):  
```
ozone_log_dir: "/var/log/hadoop"  
ozone_data_dir: "/ozone/data/hdds"  
ozone_metadata_dir: "/ozone/data/metadata"  
```

No systemd services are used.
One may just kill all the processes owned by these users and remove all the directories above.  

Example of just data deletion. Use with care:
```
ansible -m shell -a "ps -u hadoop -o pid= | xargs kill -9 || true" all
ansible -m shell -a "ps -u hive   -o pid= | xargs kill -9 || true" all

ansible -m shell -a "sh -c 'rm -rf /var/log/hadoop/*'" all
ansible -m shell -a "sh -c 'rm -rf /tmp/hadoop-hadoop/*'" all

ansible -m shell -a "sh -c 'rm -rf /ozone/data/{hdds,medatata}/*'" all
ansible -m shell -a "sh -c 'rm -rf /mnt/data/{dataNode,journalNode,nameNode}/*'" all
```
