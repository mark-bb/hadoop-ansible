#!/bin/sh
#
# Function: Prints info about all buckets size in an Ozone cluster
#

TS="$(TZ=UTC date +'%F %T%z')"
LOG="$0.log"
PROM_LOG="$0.prom"
PROM_LOG_TMP="${PROM_LOG?}.tmp"

if ! command -v ozone &>/dev/null; then source /etc/profile.d/ozone.sh; fi

cat <<EOF > "${PROM_LOG_TMP?}"
# HELP ozone_bucket_used_bytes usedBytes bucket metric
# TYPE ozone_bucket_used_bytes gauge
EOF

ozone sh volume list | jq -r ".[].name" | while read -r vol; do
  line=$(ozone sh bucket list ${vol?} | jq -r ".[] | select(has(\"usedBytes\")) | [\"${TS?}\", .volumeName, .name, .usedBytes] | @csv")
  if [ ${#line} -eq 0 ] || [ "${line:0:1}" == "," ]; then continue; fi
  printf "${line?}" | awk -F',' '{print $1","$2","$3","int($4/1024/1024)}' >> "${LOG?}"
  printf "${line?}" | awk -F',' '{print "ozone_bucket_used_bytes{volume="$2",bucket="$3"} "$4}' >> "${PROM_LOG_TMP?}"
done

mv "${PROM_LOG_TMP?}" "${PROM_LOG?}"
