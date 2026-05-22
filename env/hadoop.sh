export HADOOP_HOME="/opt/hadoop"
export PATH=${PATH}:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin
export HADOOP_USER_NAME=hadoop
# These 2 variables are used by Spark
export HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
export LD_LIBRARY_PATH="${HADOOP_HOME}/lib/native:${LD_LIBRARY_PATH}"
export TEZ_HOME="/opt/tez"
export TEZ_JARS=${TEZ_HOME}
export TEZ_CONF_DIR=${TEZ_HOME}/conf
