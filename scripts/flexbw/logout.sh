#!/bin/bash

token=`cat token.txt`

echo "$token"

curl \
--request DELETE \
--header "portal-token: [[$token]]" \
--header "Content-Type: application/json" \
https://api.consoleconnect.com/api/auth/token

