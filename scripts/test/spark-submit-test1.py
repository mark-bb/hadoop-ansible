from pyspark.sql import SparkSession
import pyspark.sql.functions as F


spark = SparkSession.builder \
        .config("spark.hadoop.hive.exec.dynamic.partition", "true") \
        .config("spark.hadoop.hive.exec.dynamic.partition.mode", "nonstrict") \
        .appName("spark-submit-test1").enableHiveSupport().getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

table = "test_tbl_hive"
rows2gen = 1
write_mode='append'

spark.sql('show tables in default').show()

df = spark.sql("select max(id) from " + table)
id_start = 0 if df.count() == 0 else (df.first()[0])
print(f'max_id: {id_start}')

spark.range(0, rows2gen) \
        .withColumn("main_id", (F.col("id") + 1 + id_start).cast("int")) \
        .withColumn("str_val", F.col("main_id").cast("string")) \
        .select( \
        F.col("main_id").alias("id"), \
        F.col("str_val").alias("str1"), \
        F.col("str_val").alias("str2"), \
        F.col("str_val").alias("str3") \
        ) \
        .write \
        .mode(write_mode) \
        .format("hive") \
        .saveAsTable(table)

spark.sql('select * from ' + table + ' order by id desc').show(5, truncate=False)

spark.stop()
