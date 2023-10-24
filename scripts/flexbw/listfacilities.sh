#!/bin/bash

token=`cat token.txt`

echo "$token"

curl \
--header "portal-token: $token" \
--header "Content-Type: application/json" \
https://api.consoleconnect.com/api/search?type=dataCenterFacilities \
| grep 'website\|businessType\|address\|city\|state\|zip\|country\|name\|username\|id'
