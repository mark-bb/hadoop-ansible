for service in SCM OM S3G; do
for host in ozone-control-01 ozone-control-02 ozone-control-03 ozone-s3gw; do

f=files/kerberos/keytabs/${host?}.ozon.local.${service?}.keytab
rm -f ${f?}

cat <<EOF | ktutil
rkt ../kerberos/${host?}.ozon.local.${service?}.keytab
rkt ../kerberos/${host?}.ozon.local.host.keytab
wkt ${f?}
q
EOF

done
done
