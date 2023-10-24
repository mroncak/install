#!/bin/bash

token=$(curl \
        --request PUT \
        --header "Content-Type: application/json" \
        --data-binary "{\"email\": \"michal.roncak@marlink.com\", \"password\": \"dhe32D!klslxk\"}" \
        https://api.consoleconnect.com/api/auth/token | \
        grep token | \
        cut -b 13-76)

curl \
--request DELETE \
--header "Content-Type: application/json" \
--header "portal-token: $token" \
https://api.consoleconnect.com/api/auth/token
