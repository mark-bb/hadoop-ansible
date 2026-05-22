for item in $(grep -v '^#' machines.txt); do
	h=${item#*@}
	files=$(ls files/kerberos/keytabs/${h?}.{SCM,OM,S3G}.keytab 2>/dev/null)
	if [ $? -eq 0 ]; then
		printf "\n${h?}:\n"
		# ls -l files/kerberos/keytabs/${h?}.host.keytab
		cat files/kerberos/keytabs/${h?}.host.keytab | ssh ${item?} -- sudo sh -c \"cat \> /etc/krb5.keytab\"
		for file in ${files?}; do
			keytab=$(printf ${file?} | sed 's/.*\.\([^\.]\+\.keytab\)$/\1/')
			# echo ${file?}
			# echo ${keytab?}
			# cat ${file?} | ssh ${item?} -- sudo sh -c \"cat \> /etc/security/keytabs/${keytab?}\"
			
			# host principal to /etc/krb5.keytab 
		done
		ssh ${item?} -- sudo ls -l /etc/security/keytabs/
	fi
done
