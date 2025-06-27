#!/bin/bash

# PROVIDER=$1
# CONSUMER=$2
# PORT=$3

PROVIDER=hospital
CONSUMER=lab
PORT=29193 # this is consumer's http.management.port

contract_file="contract.txt"

template_file="transfer/transfer-02-provider-push/resources/start-transfer-$PROVIDER-$CONSUMER.json"
output_file="transfer/transfer-02-provider-push/resources/start-transfer-$PROVIDER-$CONSUMER-v1.json"

contract_id=$(jq -r '.contractAgreementId' "$contract_file")

echo "Contract ID: ${contract_id}"

sed "s/{placeholder}/$contract_id/g" "$template_file" > "$output_file"

curl -X GET "http://localhost:$PORT/management/v3/contractagreements/${contract_id}" \
    -s | jq
    

transfer_id=$(curl -X POST "http://localhost:$PORT/management/v3/transferprocesses" \
    -H "Content-Type: application/json" \
    -d @"$output_file" \
    -s | jq -r '.["@id"]')

echo "Transfer ID: ${transfer_id}"

sleep 5

curl "http://localhost:$PORT/management/v3/transferprocesses/${transfer_id}" -s | jq

rm -f "${output_file}"
rm -f "${contract_file}"