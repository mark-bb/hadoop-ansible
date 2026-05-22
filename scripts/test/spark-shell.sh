spark-shell --master spark://astra181-scylla-04.internal:7077 \
--conf spark.ui.prometheus.enabled=true \
--conf spark.executor.processTreeMetrics.enabled=true
