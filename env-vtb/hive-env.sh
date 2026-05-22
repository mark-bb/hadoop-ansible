export HADOOP_HEAPSIZE=2048
#source /etc/profile.d/hadoop.sh 
#export HIVE_AUX_JARS_PATH=/share/ozone/lib/ozone-filesystem-hadoop3-1.4.0.jar
# BEGIN ANSIBLE MANAGED BLOCK FOR HIVE_AUX_JARS_PATH #
export HIVE_AUX_JARS_PATH=/opt/ozone/share/ozone/lib/ozone-filesystem-hadoop3-2.0.0.jar:/opt/tez:/opt/tez/lib
# END ANSIBLE MANAGED BLOCK FOR HIVE_AUX_JARS_PATH #
