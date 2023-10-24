#!/bin/bash

token=`cat token.txt`


connectionid="5fa4276cf070f40014aa2b1a"         ## 5fb3bb0ba9a3f600142d9c85 SHARED_BWAN_PTH2-SYD_PNO007218
                                                ## 5fa4261ac2e96e001426c478 E-SBM-SITE20_AM4
                                                ## 5fa4276cf070f40014aa2b1a E-SBM-SITE21_AM5

read -p "Enter requested BW: " bw
						

curl \
--request POST \
--header "Content-Type: application/json" \
--header "portal-token: $token" \
--data-binary "{\"bandwidth\":$bw}" \
"https://api.consoleconnect.com/app-user/5ee25ed0d2a661001423c56b/connections/$connectionid/connection-change-requests"

