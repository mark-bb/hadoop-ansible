export HADOOP_HOME="/opt/hadoop"
export HADOOP_CONF_DIR="/opt/hadoop/etc/hadoop"
export LD_LIBRARY_PATH="${HADOOP_HOME}/lib/native:${LD_LIBRARY_PATH}"

export SPARK_HOME="/opt/spark"
#export SPARK_MASTER=spark://astra181-scylla-04.internal:7077
export SPARK_MASTER_HOST=astra181-scylla-04.internal
export SPARK_MASTER_PORT=7077
export SPARK_PUBLIC_DNS=astra181-scylla-01.internal
export PYSPARK_PYTHON=python3
export PATH=${PATH}:${SPARK_HOME}/sbin:${SPARK_HOME}/bin
export PYTHONPATH=${SPARK_HOME}/python/:${PYTHONPATH}

export SPARK_LOG_DIR="/var/log/hadoop/spark"
export SPARK_WORKER_DIR="/tmp/spark-worker-dir"
