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
#export HADOOP_CLASSPATH=/opt/ozone/share/ozone/lib/ozone-filesystem-hadoop3-1.4.0.jar:${HADOOP_CLASSPATH}
#export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${TEZ_CONF_DIR}:${TEZ_JARS}/*:${TEZ_JARS}/lib/*
# BEGIN ANSIBLE MANAGED BLOCK FOR OZONE FS JAR #
export HADOOP_CLASSPATH=/opt/ozone/share/ozone/lib/ozone-filesystem-hadoop3-2.0.0.jar:${HADOOP_CLASSPATH} 
# END ANSIBLE MANAGED BLOCK FOR OZONE FS JAR #
