#!/bin/sh
#
# Function: Prints info about all buckets size in an Ozone cluster
#

TS="$(TZ=UTC date +'%F %T%z')"
LOG="$0.log"

if ! command -v ozone &>/dev/null; then source /etc/profile.d/ozone.sh; fi

ozone sh volume list | jq -r ".[].name" | while read -r vol; do
  ozone sh bucket list ${vol?} | jq -r ".[] | select(has(\"usedBytes\")) | [\"${TS?}\", .volumeName, .name, (.usedBytes/1024/1024|floor)] | @csv" >> "${LOG?}"
done
