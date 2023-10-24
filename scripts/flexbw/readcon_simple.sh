#!/bin/bash

token=`cat token.txt`

echo "$token"

connectionid="5fa4276cf070f40014aa2b1a"         ## 5fb3bb0ba9a3f600142d9c85 SHARED_BWAN_PTH2-SYD_PNO007218
                                                ## 5fa4261ac2e96e001426c478 E-SBM-SITE20_AM4
                                                ## 5fa4276cf070f40014aa2b1a E-SBM-SITE21_AM5

curl --silent \
                --request GET \
                --header "Content-Type: application/json" \
                --header "portal-token: $token" \
                "https://api.consoleconnect.com/api/company/marlink/connections/$connectionid" \
                > json.txt

        speed=`grep \"value\" json.txt | cut -d " " -f 6 | cut -d "," -f 1`
        echo "Speed: $speed"

