#!/bin/bash

# PROVIDER=$1
# PORT=$2
# PUBLIC_PORT=$3

PROVIDER=hospital
PORT=29193 # this is consumer's http.management.port
PUBLIC_PORT=19291 # this is provider's http.public.port

contract_file="contract.txt"

template_file="transfer/transfer-03-consumer-pull/resources/start-transfer-$PROVIDER.json"
output_file="transfer/transfer-03-consumer-pull/resources/start-transfer-$PROVIDER-v1.json"

contract_id=$(jq -r '.contractAgreementId' "$contract_file")

echo "Contract ID: ${contract_id}"

sed "s/{placeholder}/$contract_id/g" "$template_file" > "$output_file"

transfer_id=$(curl -X POST "http://localhost:${PORT}/management/v3/transferprocesses" \
  -H "Content-Type: application/json" \
  -d @"${output_file}" \
  -s | jq -r '.["@id"]')

echo "Transfer ID: ${transfer_id}"

sleep 5

curl "http://localhost:${PORT}/management/v3/transferprocesses/${transfer_id}" | jq

edt_authorization=$(curl http://localhost:${PORT}/management/v3/edrs/${transfer_id}/dataaddress | jq -r '.["authorization"]')

echo "Authorization: ${edt_authorization}"

data_response=$(curl --location --request GET "http://localhost:$PUBLIC_PORT/public/" \
    --header "Authorization: ${edt_authorization}")

echo "Response: ${data_response}"

rm -f "${output_file}"
rm -f "${contract_file}"