d=files/kerberos/keytabs
cmd="echo"
cmd=""
for i in $(seq 1 4); do \
  h=astra181-scylla-0${i}.internal; \
  ${cmd?} mkdir ${d?}/${h?}; \
  for srv in SCM OM S3G HTTP DN RECON NN JN RM NM TL MR kms hive spark hbase; do \
    ${cmd?} ln -sr ${d?}/${h?}.${srv?}.keytab ${d?}/${h?}/${srv?}.keytab; \
  done; \
done
