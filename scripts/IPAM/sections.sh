#!/bin/bash

output=$(curl \
        --request GET \
        --header "Content-Type: application/json" \
	--header "token: r4QfuGrMLRdPnGhud0PzKYLZj5BdEg-D" \
        https://iptools.mc.local/api/mro/sections/ -i -k)

echo "$output" #| tee token.txt

