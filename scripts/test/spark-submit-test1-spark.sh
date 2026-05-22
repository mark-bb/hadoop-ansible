# Doesn't work
spark-submit --master spark://astra181-scylla-04.internal:7077 --deploy-mode client \
	--conf "keytab=/etc/security/keytabs/hadoop.keytab" \
	--conf "principal=hadoop@DOMAIN.COM" \
	"$(dirname $0)/spark-submit-test1.py"
