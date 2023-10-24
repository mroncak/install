#!/bin/bash
#
# Script to automate BW adjusting on PCCW connections through API
#

function authenticate {
	# Authenticate to Console Connect API and get print out the token
	curl --silent \
	        --request PUT \
        	--header "Content-Type: application/json" \
	        --data-binary "{\"email\": \"michal.roncak@marlink.com\", \"password\": \"dhe32D!klslxk\"}" \
	        https://api.consoleconnect.com/api/auth/token | \
	        grep token | \
	        cut -d "\"" -f 4
	}

function updateflexbw {
	# Update FLEX BW of a connection
	curl --silent \
		--request POST \
		--header "Content-Type: application/json" \
		--header "portal-token: $1" \
		--data-binary "{\"bandwidth\":$2}" \
		"https://api.consoleconnect.com/app-user/5ee25ed0d2a661001423c56b/connections/$3/connection-change-requests"

	# keep checking connection speed (BW) until it is changed and sleep for 1 minute between each try
	while [ "$speed1" != "$2" ]; do
		sleep 1m
		wait
		curl --silent \
                	--request GET \
                	--header "Content-Type: application/json" \
                	--header "portal-token: $token" \
                	"https://api.consoleconnect.com/api/company/marlink/connections/$connectionid" \
                	> json.txt
		speed1=`grep \"value\" json.txt | cut -d " " -f 6 | cut -d "," -f 1`
	done

	echo "$(date --utc +"%d/%m/%y %H:%M:%S") $(tput setaf 2)$3: changed to $2 Mbps$(tput sgr 0)" \
		>> auto_bw.log
	}

# create log file if it's not present
touch auto_bw.log

# authenticate by calling function
token=`authenticate`

# count number of connections for which we will check and possibly update BW
lines=`cat connectionid.txt | sed '/^\s*$/d' | wc -l`

# count variable 
i=1

# run code for each of the connections in connectionid.txt
while [ $i -le $lines ]; do
	
	# get variables from connectionid.txt (basespeed is contracted speed
	# without FLEX - no point downgrading lower, no cost saving)
	connectionid=`sed -n "$i"p connectionid.txt | cut -d " " -f 1`
	connectionname=`sed -n "$i"p connectionid.txt | cut -d " " -f 2`
	basespeed=`sed -n "$i"p connectionid.txt | cut -d " " -f 3`
	
	# get data from API for a connection and write it into temp file
	curl --silent \
		--request GET \
		--header "Content-Type: application/json" \
		--header "portal-token: $token" \
		"https://api.consoleconnect.com/api/company/marlink/connections/$connectionid" \
		> json.txt

	# get variables from temp file
	srcPortId=`grep \"srcPortId\" json.txt | cut -d "\"" -f 4`
	destPortId=`grep \"destPortId\" json.txt | cut -d "\"" -f 4`
	speed=`grep \"value\" json.txt | cut -d " " -f 6 | cut -d "," -f 1`

	# get data from API for source PORT
	curl --silent \
		--request GET \
		--header "Content-Type: application/json" \
		--header "portal-token: $token" \
		"https://api.consoleconnect.com/api/company/marlink/ports/$srcPortId" \
		> json.txt

	# get remaining speed on the source PORT
	srcRemPortSpeed=`grep \"remaining\" json.txt | cut -d " " -f 6 | cut -d "," -f 1`

	# get data from API for destination PORT
	curl --silent \
		--request GET \
		--header "Content-Type: application/json" \
		--header "portal-token: $token" \
		"https://api.consoleconnect.com/api/company/marlink/ports/$destPortId" \
		> json.txt

	# get remaining speed on the destination PORT
	destRemPortSpeed=`grep \"remaining\" json.txt | cut -d " " -f 6 | cut -d "," -f 1`

	# set variables start amd end date for utilization request
	startdate=`date +%s -d '58 min ago'`
	enddate=`date +%s`

	# set variable for utilization resolution (day | hour | minute)
	resolution="hour"

	# get utilization data from API for a connection
	curl --silent \
		--request GET \
		--header "Content-Type: application/json" \
		--header "portal-token: $token" \
		"https://api.consoleconnect.com/api/company/marlink/connections/$connectionid/utilization/?start=$startdate&end=$enddate&resolution=$resolution" \
		> utilization.txt           
	
	# get variables from utilization.txt
	rxMaxi=`grep \"rxMax\" utilization.txt | cut -d " " -f 8 | cut -d "," -f 1`     ## cut rxMax
	txMaxi=`grep \"txMax\" utilization.txt | cut -d " " -f 8 | cut -d "," -f 1`     ## cut txMax

	# convert the variables to integer
	printf -v rxMax '%d\n' $rxMaxi 2>/dev/null
	printf -v txMax '%d\n' $txMaxi 2>/dev/null

	# find out which Max is higher and set it as bwMax
	if [ $rxMax -ge $txMax ]
	then
		bwMax=$rxMax
	else
		bwMax=$txMax
	fi

	# find out if there are some empty variables and if so than log it and change nothing
	if \
		[ -z "$bwMax" ] \
		|| \
		[ -z "$speed" ] \
		|| \
		[ -z "$srcRemPortSpeed" ]\
		|| \
		[ -z "$destRemPortSpeed" ] \
		|| \
		[ -z "$rxMaxi" ] \
		|| \
		[ -z "$txMaxi" ]
	then
		echo "$(date --utc +"%d/%m/%y %H:%M:%S") $(tput setaf 1)$connectionid: ONE OR MORE VARIABLES ARE UNDEFINED$(tput sgr 0)" \
			>> auto_bw.log
	
		# if bwMax is greater or equal to 80% of the speed of connection 
		# and there is enough BW on both source and destination Ports, 
		# then set the newbw as 120% of current connection speed log it and call function to update BW
	elif \
		[ $bwMax -ge $((speed * 80 / 100)) ] \
		&& \
		[ $srcRemPortSpeed -ge $((speed * 20 / 100)) ] \
		&& \
		[ $destRemPortSpeed -ge $((speed * 20 / 100)) ]
	then
		newbw=$((speed * 120 / 100))
		echo "$(date --utc +"%d/%m/%y %H:%M:%S") $connectionid: Upgrading from $speed to $newbw Mbps" \
			>> auto_bw.log
		updateflexbw $token $newbw $connectionid
	
		# if bwMax is less or equal to 50% of current connection speed
		# and if the newbw is still greater or equal to basespeed
		# (speed which is the lowest bw we want to downgrade to),
		# then call update function to downgrade the link)
	elif \
		[ $bwMax -le $((speed * 50 / 100)) ] \
		&& \
		[ $((bwMax * 130 / 100)) -ge $basespeed ]
	then
		newbw=$((bwMax * 130 / 100))
		echo "$(date --utc +"%d/%m/%y %H:%M:%S") $connectionid: Downgrading from $speed to $newbw Mbps" \
			>> auto_bw.log
		updateflexbw $token $newbw $connectionid
		# if none of above ifs is matched don't change anything and log it
	else
		echo "$(date --utc +"%d/%m/%y %H:%M:%S") $(tput setaf 2)$connectionid No change$(tput sgr 0)" \
			>> auto_bw.log
	fi

	# increment counter
	i=$((i + 1))
done
