#!/bin/bash

# Script name: install_sudoers_util.sh
# Script author: Ian Dennison (Oct 2014)
# Script function: To verify and install sudoers utility components

# Update: 24-Oct-2014 - script to be included as part of tar archive, so no need to 
#	include uncompress and extract commands
#
function cleanup_temp_data
{
	if [[ -f /tmp/login_result.${PID} ]]
	then
		rm -f /tmp/login_result.${PID}
	fi
	if [[ -f /tmp/output_sql_${PID}.log ]]
	then
		rm -f /tmp/output_sql_${PID}.log
	fi
	if [[ -f /tmp/output_sql2_${PID}.log ]]
	then
		rm -f /tmp/output_sql2_${PID}.log
	fi
	if [[ -f /tmp/output_sql3_${PID}.log ]]
	then
		rm -f /tmp/output_sql3_${PID}.log
	fi
	if [[ -f  /tmp/user_error_${PID}.log ]]
	then
		rm -f  /tmp/user_error_${PID}.log
	fi

}

function network_selinux_setup
{
	# Component to set up ip tables (if required) and selinux
	export VALCNT=`service iptables status |grep -i "is not running" |wc -l` 
	if (( $VALCNT < 1 ))
	then
		# Ensure configured for iptables
		export CONFCNT=`grep -i "-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT" /etc/sysconfig/iptables |wc -l`
		if (( $CONFCNT < 1 ))	
		then
			# Don't trim or remove lines below on sed command
			sed -i /etc/sysconfig/iptables -e '/INPUT -j REJECT/i \
\
#  Sudoers Management System HTTPS Exception \
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT \
'
			# Now restart network services
			/etc/init.d/iptables restart
		fi
		echo "Network security config - OK"	
	fi

	# Now check selinux
	export VALCNT=`sestatus |grep -i enforcing |wc -l`
	if (( $VALCNT > 0 ))
	then
		echo "Please wait - setting Linux security"
		setsebool -P httpd_can_sendmail on
		export RC=$?
		if [[ $RC != "0" ]]
		then
			echo "Issues discovered with setting sebool - please investigate"
			cleanup_temp_data
			exit
		fi
		echo "Secure Linux config - OK"	
	fi

}

function generate_sql_schema
{
	# Check for mysql running
	export RUNNING=`/etc/init.d/mysqld status |grep -i running |wc -l`
	if (( $RUNNING < 1 ))
	then
		/etc/init.d/mysqld start
		export RUN2=`/etc/init.d/mysqld status |grep -i running |wc -l`
		if (( $RUN2 < 1 ))
		then
			echo "Could not start mysql - check and start manually"
			cleanup_temp_data
			exit 1
		fi
	fi

	if [[ ! -f /tmp/mysqlnewpass ]]
	then
		# Define root password
		echo "Enter MySQL root password:"
		read NEWPASS

		if [[ $NEWPASS = "" ]]
		then
			cleanup_temp_data
			exit
		fi

		mysqladmin -u root password "$NEWPASS"
		echo $NEWPASS > /tmp/mysqlnewpass
	else
		# Read in old pass
		export NEWPASS=`head -n 1 /tmp/mysqlnewpass`
	fi
	
	# Verify password provided
	mysql -h localhost -u root -p${NEWPASS} Sudoers -e 'show tables;' 2>&1 > /tmp/login_result.${PID}
	# ERROR 1045 (28000): Access denied for user 
	export ERRCNT=`grep -iE 'ERROR|Access denied for user' /tmp/login_result.${PID} |wc -l`
	if (( $ERRCNT > 0 ))	
	then
		echo "Could not validate password - exiting"
		cleanup_temp_data
		exit
	fi

	# Check if run previously
	export ANS='X'
	export PREVCNT=`grep -iE 'host_groups|command_groups' /tmp/login_result.${PID} |wc -l`
	if (( $PREVCNT > 0 ))
	then	
		# Check for SQL Schema and mysqladmin password already run
		echo "The following destructive command recreates the database - are you sure you wish to do this; Run, Skip or Quit? (RSQ)"
		read ANS
		if [[ $ANS = [Qq] ]]
		then
			echo "Exiting"
			cleanup_temp_data
			exit
		fi
	fi	

	# Create DB Structures - if specified (Run) or Hidden Default (X)
	if [[ $ANS = [RrXx] ]]
	then
		cd ${MDIR}/sudoers/Configs/SQL/
		mysql -u root -p${NEWPASS} < Full_Schema.sql 2>&1 > /tmp/output_sql_${PID}.log
		export ERRCNT=`grep -i error /tmp/output_sql_${PID}.log |wc -l`
		if (( $ERRCNT > 0 ))
		then
			echo "Encountered a problem - please review log"
			cat /tmp/output_sql_${PID}.log
			cleanup_temp_data
			exit 1
		fi	
		echo "Creating DB structures - OK"
	fi	

	# Now set up default users priviledges
	export ANS2=$ANS
	if [[ $ANS != [Xx] ]]
	then
		echo "Setting up default User privileges; Run, Skip, Quit?"
		read ANS2 
	fi
	if [[ $ANS2 = [RrXx] ]]
	then	
		cd ${MDIR}/sudoers/Configs/SQL/
		mysql -u root -p${NEWPASS} < Default_Users.sql 2>&1 > /tmp/output_sql2_${PID}.log
		echo "output results"
		cat /tmp/output_sql2_${PID}.log
		read
		echo "Creating user privileges - OK"
	fi

	# Confirm priviledges
	echo "Checking User Priviledges"
	echo 'show grants for Management@localhost; show grants for Sudoers@localhost;' | mysql -u root -p${NEWPASS} 2>&1 > /tmp/output_sql3_${PID}.log

	# Now loop around and check priviledges
	export ERRCNT=0
	cat /dev/null > /tmp/user_error_${PID}.log
	export GLOB=*
	while read LINE
	do
		export VALCNT=`grep -i "^${LINE}" /tmp/output_sql3_${PID}.log |wc -l`
		if (( $VALCNT < 1 ))
		then
			export ERRCNT=`expr $ERRCNT \+ 1`
			echo "$LINE" >> /tmp/user_error_${PID}.log
		fi
	done < ${MDIR}/etc/rights_list
	
	if (( $ERRCNT > 0 ))
	then	
		echo "There were $ERRCNT User permissions missing"
		cat /tmp/user_error_${PID}.log
		cleanup_temp_data
		exit 1
	else
		echo "User privileges - OK"
	fi
}

function generate_ssl_keys
{
	# Check if certs exist
	export CERTCNT=0
	if [[ -f /etc/pki/tls/certs/DSMS.crt ]]
	then
		export CERTCNT=`expr $CERTCNT \+ 1`
	fi
	if [[ -f /etc/pki/tls/private/DSMS.key ]]
	then
		export CERTCNT=`expr $CERTCNT \+ 1`
	fi
	if [[ -f /etc/pki/tls/private/DSMS.csr ]]
	then
		export CERTCNT=`expr $CERTCNT \+ 1`
	fi
	if (( $CERTCNT == 3 ))
	then
		echo "All 3 certificates currently exist - regenerate? [YN]"
		read ANS
		if [[ $ANS = [Nn] ]]
		then
			return
		fi
	fi

	# Generate certificates
	cd /tmp
	openssl genrsa -out DSMS.key 4096
	export RC=$?
	if [[ $RC != "0" ]]
	then
		echo "Could not generate RSA key - exiting"
		cleanup_temp_data
		exit 1
	fi

	# Generate SSL Key (leave the 2 lines empty before EOF, they are needed as placeholders)
	openssl req -new -key DSMS.key -out DSMS.csr <<EOF
NZ
 Systems (Wellington)
DWLWG Unix Projects
 Sudoers Management System
DSMS
DSMS
ben@nwk1.com


EOF

	export RC=$?
	if [[ $RC != "0" ]]
	then
		echo "Could not generate DSMS RSA key - exiting"
		cleanup_temp_data
		exit 1
	fi

	# Generate key and crt
	openssl x509 -req -days 3652 -in DSMS.csr -signkey DSMS.key -out DSMS.crt
	export RC=$?
	if [[ $RC != "0" ]]
	then
		echo "Could not generate DSMS key and crt files - exiting"
		cleanup_temp_data
		exit
	fi
	
	# Copy files out
	cp DSMS.crt /etc/pki/tls/certs
	export RCODE=$?
	rm DSMS.crt
	cp DSMS.key /etc/pki/tls/private/DSMS.key
	export RCODE=$RCODE$?
	rm DSMS.key
	cp DSMS.csr /etc/pki/tls/private/DSMS.csr
	export RCODE=$RCODE$?
	rm DSMS.csr

	# Check if selinux 	
	export SESTATUS=`sestatus |grep -i "Current mode:" |awk '{print $NF}'`
	if [[ $SESTATUS = "enforcing" ]]
	then
		# Restore context
		restorecon -vRF /etc/pki		
		export RCODE=$RCODE$?
	fi	

	# Check if referencing SSL keys
	export VALCNT=`grep -i "#  Sudoers Management System SSL Configuration" /etc/httpd/conf/httpd.conf |wc -l`
	if (( $VALCNT > 0 ))
	then
		# Check if entries exist
		export SECCNT=`grep -iE "SSLCertificateFile /etc/pki/tls/certs/DSMS.crt|SSLCertificateKeyFile /etc/pki/tls/private/DSMS.key" /etc/httpd/conf/httpd.conf |wc -l`
		if (( $SECCNT != 2 ))
		then
			echo "443 SSL Key Entry Lines are missing from /etc/httpd/conf/httpd.conf - please upodate manually"
			export RCODE=$RCODE"1"
		fi
	else
		# Check if 443 already used
		export SECCNT=`grep '<VirtualHost *:443>' /etc/httpd/conf/httpd.conf  |wc -l`
		if (( $SECCNT > 0 ))
		then	
			# Already exists- error
			echo "443 SSL Key Entry Lines are incomplete in /etc/httpd/conf/httpd.conf - please upodate manually"
			export RCODE=$RCODE"1"
		else
			echo '#  Sudoers Management System SSL Configuration' >> /etc/httpd/conf/httpd.conf
			echo '<VirtualHost *:443>' >> /etc/httpd/conf/httpd.conf
			echo '    SSLEngine on' >> /etc/httpd/conf/httpd.conf
			echo '    SSLCertificateFile /etc/pki/tls/certs/DSMS.crt' >> /etc/httpd/conf/httpd.conf
			echo '    SSLCertificateKeyFile /etc/pki/tls/private/DSMS.key' >> /etc/httpd/conf/httpd.conf
			echo '    <Directory /var/www/html>' >> /etc/httpd/conf/httpd.conf
			echo '        AllowOverride All' >> /etc/httpd/conf/httpd.conf
			echo '    </Directory>' >> /etc/httpd/conf/httpd.conf
			echo '    DocumentRoot /var/www/html' >> /etc/httpd/conf/httpd.conf
			echo '    ServerName DSMS' >> /etc/httpd/conf/httpd.conf
			echo '</VirtualHost>' >> /etc/httpd/conf/httpd.conf
		fi
		
	fi

	# Check if any errors found
	export NEWCODE=`echo $RCODE |sed 's/0/ /g' |awk '{print NF}'`
	if (( $NEWCODE > 0 ))
	then
		echo "Errors with commands above - please review and correct"
		cleanup_temp_data
		exit 1
	fi

}

function update_apache_config
{
	# Check if /etc/httpd/conf/httpd.conf
	if [[ ! -f /etc/httpd/conf/httpd.conf ]]
	then
		echo "Could not find /etc/httpd/conf/httpd.conf - exiting"
		cleanup_temp_data
		exit 1
	fi

	# Now update contents of files, always check if required
	export ERRCNT=0
	export INDXCNT=`grep -i "^DirectoryIndex" /etc/httpd/conf/httpd.conf |grep -i index.cgi |wc -l`
	if (( $INDXCNT < 1 ))
	then
		sed -e 's/^DirectoryIndex/DirectoryIndex index.cgi/' -i /etc/httpd/conf/httpd.conf
		export RC=$?
		if [[ $RC != "0" ]]
		then
			echo "Could not modify 'DirectoryIndex index.cgi' on /etc/httpd/conf/httpd.conf"
			export ERRCNT=`expr $ERRCNT \+ 1`
		fi
	fi
		
	# Check to modify Server Admin
	export VALCNT=`grep "^ServerAdmin" /etc/httpd/conf/httpd.conf |grep -i "root@localhost" |wc -l`
	if (( $VALCNT > 0 ))
	then
		sed -e 's/^ServerAdmin */ServerAdmin ben@nwk1.com/' -i /etc/httpd/conf/httpd.conf
		export RC=$?	
		if [[ $RC != "0" ]]
		then
			echo "Could not modify 'ServerAdmin root@localhost' on /etc/httpd/conf/httpd.conf"
			export ERRCNT=`expr $ERRCNT \+ 1`
		fi
	fi

	# Check Server Name exists
	export VALCNT=`grep -i "^ServerName DSMS" /etc/httpd/conf/httpd.conf |wc -l`
	if (( $VALCNT < 1 ))
	then
		# Need top add
		export EXISTCNT=`grep -i "^ServerName www.example.com:80" /etc/httpd/conf/httpd.conf |wc -l`
		if (( $EXISTCNT < 1 ))
		then
			# Error - no base entry to change
			echo "Could not find 'ServerName www.example.com:80' on /etc/httpd/conf/httpd.conf to copy"
			export ERRCNT=`expr $ERRCNT \+ 1`
		else
			sed -e 's/^ServerName www.example.com:80/ServerName DSMS/' -i /etc/httpd/conf/httpd.conf
			export RC=$?
			if [[ $RC != "0" ]]
			then
				echo "Could not modify 'ServerName www.example.com:80' on /etc/httpd/conf/httpd.conf to DSMS"
				export ERRCNT=`expr $ERRCNT \+ 1`
			fi
		fi
	fi	
	
	# Check for CGI handlers
	export VALCNT=`grep -i " Sudoers Management System CGI Handlers" /etc/httpd/conf/httpd.conf |wc -l`
	if (( $VALCNT < 1 ))
	then
		# Append to httopd.conf
		echo "#  Sudoers Management System CGI Handlers" >> /etc/httpd/conf/httpd.conf
		echo "AddHandler cgi-script .cgi .pl" >> /etc/httpd/conf/httpd.conf
		echo '<Files ~ "\.pl$">' >> /etc/httpd/conf/httpd.conf
		echo '    Options +ExecCGI' >> /etc/httpd/conf/httpd.conf
		echo '</Files>' >> /etc/httpd/conf/httpd.conf
		echo '<Files ~ "\.cgi$">' >> /etc/httpd/conf/httpd.conf
		echo '	 Options +ExecCGI' >> /etc/httpd/conf/httpd.conf
		echo '</Files>' >> /etc/httpd/conf/httpd.conf
	fi

	if (( $ERRCNT > 0 ))
	then
		cleanup_temp_data
		exit 1
	fi	
	/etc/init.d/httpd restart
	export RC=$?
	if [[ $RC != "0" ]]
	then
		echo "Could not restart Apache"
		cleanup_temp_data
		exit 1
	fi
}

function update_apache_files
{
	# Set of commands to update apache - run through detecting return codes and report at end
	cat /dev/null > /tmp/output_work.${PID}
	export RCODE=""
	export SAVEENVS=N
	if [[ -d /var/www/html/HTTP ]]
	then
		export RC=0
		echo "   -   Directory /var/www/html/HTTP already exists - copy or quit[YNQ]?"
		read ANS
		if [[ $ANS = [Qq] ]]
		then
			echo "Quitting"
			cleanup_temp_data
			exit
		fi
	
		# Check for modifications to environment_variables
		if [[ -f /var/www/html/HTTP/environmental-variables ]]
		then
			diff /var/www/html/HTTP/environmental-variables ${MDIR}/sudoers/HTTP/environmental-variables 2>&1 > /dev/null
			export DIFFVAL=$?
			if [[ $DIFFVAL != "0" ]]
			then
				echo "local environment_variables file has been changed, overwrite? [YN]"
				read ANS
				if [[ $ANS = [Nn] ]]
				then
					cp /var/www/html/HTTP/environmental-variables /tmp/environmental-variables.${PID}
					export SAVEENVS=Y
				fi
			fi
		fi

		if [[ $ANS = [Yy] ]]
		then
			cp -rp ${MDIR}/sudoers/HTTP /var/www/html
			export RC=$?
		fi
	else	
		mv ${MDIR}/sudoers/HTTP/ /var/www/html
		export RC=$?
	fi
	if [[ $RC != "0" ]]
	then
		# Fail at first hurdle
		echo "Could not copy ${MDIR}/sudoers/HTTP/ to /var/www/html - stopping."
		cleanup_temp_data
		exit
	fi
	
	# Check for and copy back environment variables
	if [[ $SAVEENVS = [Yy] ]]
	then
		cp /tmp/environmental-variables.${PID} /var/www/html/HTTP/
	fi

	# Loop through performing commands and checking output
	echo "cd /var/www/html/HTTP" >> /tmp/output_work.${PID}
	cd /var/www/html/HTTP 2>&1 >> /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	echo "touch sudoers" >> /tmp/output_work.${PID}
	touch sudoers	2>&1 >> /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	if [[ ! -d sudoers-storage ]]
	then	
		echo " mkdir sudoers-storage" >> /tmp/output_work.${PID}
		mkdir sudoers-storage 2>&1 >> /tmp/output_work.${PID}
		export RCODE="$RCODE"$?
	fi	

	echo "chown root:apache *.cgi" >>  /tmp/output_work.${PID}
	chown root:apache *.cgi 2>&1  >>  /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	echo "chmod 650 *.cgi" >>  /tmp/output_work.${PID}
	chmod 650 *.cgi 2>&1  >>  /tmp/output_work.${PID}
	export RCODE="$RCODE"$?
	
	echo "chown root:apache common.pl" >> /tmp/output_work.${PID}
	chown root:apache common.pl >> /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	echo "chmod 650 common.pl" >> /tmp/output_work.${PID}
	chmod 650 common.pl >> /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	echo "chown root:root sudoers-build.pl distribution.pl" >> /tmp/output_work.${PID}
	chown root:root sudoers-build.pl distribution.pl >> /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	echo "chmod 100 sudoers-build.pl distribution.pl" >> /tmp/output_work.${PID}
	chmod 100 sudoers-build.pl distribution.pl >> /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	echo "chown root:apache environmental-variables sudoers" >> /tmp/output_work.${PID}
	chown root:apache environmental-variables sudoers >> /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	echo "chmod 640 environmental-variables sudoers" >> /tmp/output_work.${PID}	
	chmod 640 environmental-variables sudoers >> /tmp/output_work.${PID}	
	export RCODE="$RCODE"$?

	echo "chown -R root:apache format.css favicon.ico resources/" >> /tmp/output_work.${PID}
	chown -R root:apache format.css favicon.ico resources/ >> /tmp/output_work.${PID}
	export RCODE="$RCODE"$?

	echo "chmod -R 440 format.css favicon.ico resources/" >>  /tmp/output_work.${PID}	
	chmod -R 440 format.css favicon.ico resources/ >>  /tmp/output_work.${PID}	
	export RCODE="$RCODE"$?

	echo "chown root:apache resources/ resources/imgs/ resources/imgs/buttons/" >> /tmp/output_work.${PID}	
	chown root:apache resources/ resources/imgs/ resources/imgs/buttons/ >> /tmp/output_work.${PID}	
	export RCODE="$RCODE"$?

	echo "chmod 550 resources/ resources/imgs/ resources/imgs/buttons/" >> /tmp/output_work.${PID}	
	chmod 550 resources/ resources/imgs/ resources/imgs/buttons/ >> /tmp/output_work.${PID}	
	export RCODE="$RCODE"$?

	echo "chown -R root:root sudoers-storage/" >> /tmp/output_work.${PID}	
	chown -R root:root sudoers-storage/ >> /tmp/output_work.${PID}	
	export RCODE="$RCODE"$?

	echo "chmod -R 700 sudoers-storage/" >> /tmp/output_work.${PID}	
	chmod -R 700 sudoers-storage/ >> /tmp/output_work.${PID}	
	export RCODE="$RCODE"$?

	# Check if return code
	export NEWRC=`echo "$RCODE" |sed 's/0/ /g' |awk '{print NF}'`
	if [[ $NEWRC != "0" ]]
	then
		# Received one error
		echo "Found $NEWRC failures upon rollout - please review and approve"
		cat /tmp/output_work.${PID}

		echo
		echo " Continue?"
		read ANS
		if [[ $ANS = [Yy] ]]
		then
			export NEWRC=0
		else
			cleanup_temp_data
			exit
		fi
	fi	

	# Check for selinux
	export SESTATUS=`sestatus |grep -i "Current mode:" |awk '{print $NF}'`
	if [[ $SESTATUS = "enforcing" ]]
	then
		# Restore context
		restorecon -vRF /var/www/html 2>&1 > /tmp/restcon.${PID}
		export RC=$?
		if [[ $RC != "0" ]]
		then
			echo "Error with restorecon on  /var/www/html"
			cat /tmp/restcon.${PID}
			cleanup_temp_data
			exit 1
		fi
	fi	
}

function rollout_code
{
	# Check for httpd running	
	export VALCNT=`service httpd status 2>&1 |grep -i "is running" |wc -l`
 	if (( $VALCNT < 1 ))
	then
		echo "Service httpd is not running - please start"
		cleanup_temp_data
		exit
	fi

	# Checksum on files
	cd ${MDIR}/sudoers
	md5sum -c checksums 2>&1 > /tmp/checksum_log

	export FAILCNT=`cat /tmp/checksum_log |grep "FAILED$" |wc -l`
	if (( $FAILCNT > 0 ))
	then
		# print error messages - loop around and check sums
		echo "Failures detected in checksum of contents of zip file"
		cat /tmp/checksum_log |grep "FAILED$" > /tmp/work_file1.${PID}
		export LNCOUNT=`cat /tmp/work_file1.${PID} |wc -l`
		while (( $LNCOUNT > 0 ))
		do
			export LINE1=`head -n 1 /tmp/work_file1.${PID}`
			export FIELD1=`echo "$LINE1" |awk -F":" '{print $1}'`
			export DOCSUM=`grep -i "$FIELD1$" checksums |awk '{print $1}'`
			export CURRSUM=`md5sum "$FIELD1" |awk '{print $1}'`

			echo "Field $FIELD1 - DOCSUM $DOCSUM CURRSUM $CURRSUM"
		
			grep -v "$LINE1" /tmp/work_file1.${PID} > /tmp/work_file1.${PID}_2
			mv /tmp/work_file1.${PID}_2 /tmp/work_file1.${PID}	
			export LNCOUNT=`cat /tmp/work_file1.${PID} |wc -l`
		done
		echo "return to continue"
		read	
	fi

}

function check_perl_modules
{
        export ERRCNT=0;export VALCNT=0
	export ERRMOD=""
        for i in $(cat ${MDIR}/etc/module_list)
        do
                echo "#!/bin/bash" > /tmp/query_perl.sh
                echo "perl -M${i} -e 'print \"${i}::VERSION \. \\\n\";' 2>&1 > /dev/null" >> /tmp/query_perl.sh
                echo "exit \$?" >> /tmp/query_perl.sh

                sh /tmp/query_perl.sh 2>&1 > /dev/null
                export RC=$?
		if [[ $RC == "0" ]]
		then
			export VALCNT=`expr $VALCNT \+ 1`
		else
			export ERRCNT=`expr $ERRCNT \+ 1`
			export ERRMOD="$ERRMOD $i"
		fi

        done

	if (( $ERRCNT > 0 ))
	then
		echo "There were $ERRCNT Perl Modules missing"
		echo " Modules $ERRMOD"
		echo
		echo " Try download using cpan"
		cleanup_temp_data
		exit
	fi
}

# Script to install sudoers password utility
function check_package_depend
{
	# Routine to check package dependencies
	export ERR_CNT=0
	for i in $(cat ${MDIR}/etc/package_list)
	do
		export FNDCNT=`grep -i "^$i" /tmp/package_list.${PID} |wc -l`
		if (( $FNDCNT < 1 ))
		then
			export ERR_CNT=`expr $ERR_CNT \+ 1`
			echo "Package $i is missing or too low"
		fi
	done

	# Now check binaries
        for i in $(cat ${MDIR}/etc/binary_list)
        do
                which $i 2>&1 > /dev/null
		export RC=$?
                if (( $RC > 0 ))
                then
                        export ERR_CNT=`expr $ERR_CNT \+ 1`
                        echo "Binary $i is missing"
                fi
        done
	
	if (( $ERR_CNT > 0 ))
	then
		echo
		echo "Some errors were encountered - please correct before progressing"
		cleanup_temp_data
		exit
	fi

	# Check ssl module
	export VALCNT=`rpm -qa |grep mod_ssl |wc -l`
	if (( $VALCNT < 1 ))
	then
		echo "SSL Not loaded, please correct"
		cleanup_temp_data
		exit
	fi	
}

# Main Loop

# Pre-req - confirm root
export PID=$$
export PARAM=$0
export MDIR=`pwd`
export WHOAMI=`whoami`
export ERRCODE=0
if [ $WHOAMI != "root" ]
then
	echo "This is a root only utility - exiting"
	cleanup_temp_data
	exit 1
fi

# Check being run in directory
export HIGHDIR=`pwd |sed 's/\// /g' |awk '{print $NF}'`
if [[ $HIGHDIR != "sudoers" ]]
then
	echo "Script must be run in the extracted sudoers directory"
	exit 1
fi

# Check being run with ./
export STARTCMD=`echo $PARAM |awk '{print substr($1, 1, 1)}'`
if [[ $STARTCMD != "." ]]
then
	echo "Script must start with \"./\" - was started with $STARTCMD"
	exit 1
fi
# pre-requisite checks - check release
export COMPAT=0
if [ -f /etc/redhat-release ]
then	
	export OSVER=`cat /etc/redhat-release |awk '{print substr($7, 1, 1)}'`
	if [[ $OSVER = "6" ]]
	then
		export COMPAT=`expr $COMPAT \+ 1`
		/bin/rpm -qa > /tmp/package_list.${PID}
	fi
fi

if [[ -f /etc/lsb-release && ! -f /etc/redhat-release ]]
then
	export OS_VER=`grep -i "DISTRIB_RELEASE" /etc/lsb-release |head -n 1| sed 's/=/ /g' |sed 's/\./ /g' |awk '{print $2}'`

	if (( $OS_VER > 13 ))
	then
		export COMPAT=1
		dpkg --get-selections > /tmp/package_list.${PID}
	fi
fi	
if [[ $COMPAT != "1" ]]
then
	echo "Current OS is not compatible with this utility - RH 6 or greater, Ubtuntu 14 or better"
	cleanup_temp_data
	exit 1
fi

echo "Checking OS dependencies - OK"

# Check package dependencies
check_package_depend

echo "Checking package dependencies - OK"

# Check perl modules
check_perl_modules

# If reached here, all clear
if [[ $ERRCODE != "0" ]]
then
	# exit as error code found
	echo "Preinstallation checks have found errors - please correct and re-run"
	cleanup_temp_data
	exit 1
fi

echo "Checking Perl Modules - OK"

# Now rollout code
rollout_code

echo "Rolling out code - OK"

# Now update apache
update_apache_files

echo "Updating Apache files - OK"

# Now update apache config files
update_apache_config

echo "Updating Apache config - OK"

# Generate SSL keys
generate_ssl_keys
echo "Updated ssl keys - OK"

# Generate SQL
generate_sql_schema

# Configure network and security
network_selinux_setup

echo "Installation complete"
