#!/bin/bash

token=`cat token.txt`

startdate=`date +%s -d '44 min ago'`
startdate_h=`date -d @$(($startdate))`
enddate=`date +%s`
enddate_h=`date -d @$(($enddate))`

connectionid="5fa4261ac2e96e001426c478"		## 5fb3bb0ba9a3f600142d9c85 SHARED BWAN PTH2-SYD PNO007218
						## 5fa4261ac2e96e001426c478 E-SBM-SITE20_AM4
						## 5fa4276cf070f40014aa2b1a E-SBM-SITE21_AM5
resolution="hour"				## day | hour | minute

echo "start=$startdate > $startdate_h"
echo "end=$enddate > $enddate_h"

curl --silent \
--request GET \
--header "Content-Type: application/json" \
--header "portal-token: $token" \
"https://api.consoleconnect.com/api/company/marlink/connections/$connectionid/utilization/?start=$startdate&end=$enddate&resolution=$resolution" \
> utilization.txt

rxMax=`grep \"rxMax\" utilization.txt | cut -d " " -f 8 | cut -d "," -f 1`
txMax=`grep \"txMax\" utilization.txt | cut -d " " -f 8 | cut -d "," -f 1`

echo "rxMax: $rxMax"
echo "txMax: $txMax"
