#!/bin/bash

token=`cat token.txt`

echo "$token"

curl \
--request GET \
--header "Content-Type: application/json" \
--header "portal-token: $token" \
https://api.consoleconnect.com/api/company/marlink/connections/

