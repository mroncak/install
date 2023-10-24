#!/bin/bash

#curl --silent \
#     --request GET \
#     --header "ouYMrP7lMSqmKz7CStJyTFJI9agT_kOc" \
#        https://iptools.mc.local/api/mro/subnets/all/ -i -k > ipam_db.json
     #--header "Content-Type: application/json" \

# Convert json to csv with only specific subjects
tail -n 1 ipam_db.json | jq -r '.data[] | [.id, .subnet, .mask, .description, .masterSubnetId, .vrfId, .sectionId, ."custom_T-IP"] | join(";")' > ipam_db.csv

# filter public IP addresses only
awk -F';' '$2 !~ /'^10\\.\\.*$'/ && $2 !~ /'^192\\.168\\.\\.*$'/ && $2 !~ /'^172\\.1[6-9]\\.\\.*$'/ && $2 !~ /'^172\\.2[0-9]\\.\\.*$'/ && $2 !~ /'^172\\.3[0-1]\\.\\.*$'/ && $2 !~ /'^198\\.1[8-9]\\.\\.*$'/'  ipam_db.csv > ipam_db_public.csv

# filter entries without TIP filled in
awk -F';' '!length($8)' ipam_db_public.csv > ipam_db_notip.csv

